//
//  SessionManager.swift
//  NetworkPlatform
//
//  Created by Pritam on 9/9/21.
//

import Foundation
import KeychainAccess
import RxSwift
import Alamofire
import AppAuth
import Moya

public class SessionManager {
    
    private enum Key: String {
        case authState
    }
    
    public static let shared = SessionManager()

    private let authenticator: AuthAuthenticator
    private let interceptor: AuthenticationInterceptor<AuthAuthenticator>
    private let sessionManager: Session
    
    private var disposeBag = DisposeBag()
    
    private init() {
        authenticator = AuthAuthenticator()
        interceptor = AuthenticationInterceptor(authenticator: authenticator)
        let configuration = URLSessionConfiguration.ephemeral
        sessionManager = Session(configuration: configuration, interceptor: interceptor)
        addCredential()
    }
    
    public func loadAuthState() throws -> OIDAuthState? {
        if let authStateData = try keychain.getData(Key.authState.rawValue) {
            let authState = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(authStateData) as? OIDAuthState
            return authState
        }
        return nil
    }
    
    public func writeAuthInfo(authState: OIDAuthState?) {
        guard let authState = authState else {
            removeAuthState()
            return }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: authState, requiringSecureCoding: false)
            try keychain.set(data, key: Key.authState.rawValue)
        } catch {
            log.debug("Couldn't write auth state")
        }

        self.addCredential()
    }
    
    func removeAuthState() {
        do {
            try keychain.remove(Key.authState.rawValue)
        } catch let ex {
            log.error("Remove auth state failed: \(ex.localizedDescription)")
        }

        self.removeCredential()
    }

    var accessToken: String? {
        do {
            let authState = try loadAuthState()
            let token = authState?.lastTokenResponse?.accessToken
            return token
        } catch let error {
            log.debug("Read access token failed: \(error.localizedDescription)")
        }
        return nil
    }

    var refreshToken: String? {
        do {
            let authState = try loadAuthState()

            let token = authState?.lastTokenResponse?.refreshToken
            return token
        } catch let error {
            log.debug("Read refresh token failed: \(error.localizedDescription)")
        }
        return nil
    }

    private var expiry: Date? {
        do {
            let authState = try loadAuthState()
            let expiry = authState?.lastTokenResponse?.accessTokenExpirationDate
            return expiry
        } catch let error {
            log.debug("Read expiry failed: \(error.localizedDescription)")
        }
        return nil
    }

    private var expired: Bool {
        if let expiry = expiry {
            return expiry.isInPast
        }
        return true
    }

    var isTokenValid: Bool {
        do {
            let authState = try loadAuthState()

            let isValid = authState?.isAuthorized
            return isValid ?? false
        } catch let error {
            log.debug("Read authorization state failed: \(error.localizedDescription)")
        }

        return false
    }
    
    // MARK: - Private
    private let keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "")
    
    func destroySession() {
        do {
            try keychain.removeAll()
        } catch let error {
            log.error(error)
        }
    }

    var session: Session {
        return sessionManager
    }

    let sessionWithoutCredentials: Session = {
        let configuration = URLSessionConfiguration.ephemeral
        let sessionManager = Session(configuration: configuration)
        return sessionManager
    }()

    private func addCredential() {
        if let accessToken = self.accessToken,
            let refreshToken = self.refreshToken,
            let expiry = self.expiry {
            let credential = AuthCredential(accessToken: accessToken,
                                            refreshToken: refreshToken,
                                            expiration: expiry)
            self.interceptor.credential = credential
        }
    }

    private func removeCredential() {
        self.interceptor.credential = nil
    }
}

struct AuthCredential: AuthenticationCredential {
    let accessToken: String
    let refreshToken: String
    let expiration: Date

    var requiresRefresh: Bool { Date(timeIntervalSinceNow: 10) > expiration }
}

class AuthAuthenticator: Authenticator {
    typealias Credential = AuthCredential
    private let session: Session = {
            let configuration = URLSessionConfiguration.default
            return Session(configuration: configuration)
        }()

    func apply(_ credential: AuthCredential, to urlRequest: inout URLRequest) {
        urlRequest.headers.add(.authorization(bearerToken: credential.accessToken))
    }

    func refresh(_ credential: AuthCredential,
                 for session: Session,
                 completion: @escaping (Result<AuthCredential, Error>) -> Void) {
        refreshTokens { (result) in
            completion(result)
        }
    }

    func didRequest(_ urlRequest: URLRequest,
                    with response: HTTPURLResponse,
                    failDueToAuthenticationError error: Error) -> Bool {
        return response.statusCode == HTTPStatusCodes.unauthorized.rawValue
    }

    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: AuthCredential) -> Bool {
        let bearerToken = HTTPHeader.authorization(bearerToken: credential.accessToken).value
        return urlRequest.headers["Authorization"] == bearerToken
    }

    private func refreshTokens(completion: @escaping (Result<AuthCredential, Error>) -> Void) {
        do {
            let sessionManager = SessionManager.shared
            let authState = try sessionManager.loadAuthState()
            if let tokenRefreshRequest = authState?.tokenRefreshRequest() {
                OIDAuthorizationService.perform(tokenRefreshRequest) { (tokenResponse, error) in
                    authState?.update(with: tokenResponse, error: error)
                    sessionManager.writeAuthInfo(authState: authState)

                    if let error = error {
                        log.debug("Token Refresh failed: \(error)")
                        completion(.failure(error))
                        return
                    }

                    if let accessToken = authState?.lastTokenResponse?.accessToken,
                        let refreshToken = authState?.lastTokenResponse?.refreshToken,
                        let expiration = authState?.lastTokenResponse?.accessTokenExpirationDate {
                        let credential = AuthCredential(
                            accessToken: accessToken,
                            refreshToken: refreshToken,
                            expiration: expiration)

                        completion(.success(credential))
                    }
                }
            }
        } catch let error {
            log.debug("Token refresh failed: \(error)")
            completion(.failure(error))
        }
    }
}

private extension Date {
    var isInPast: Bool {
        let now = Date()
        return self.compare(now) == ComparisonResult.orderedAscending
    }
}
