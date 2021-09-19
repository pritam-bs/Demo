//
//  AuthDataManager.swift
//  Demo
//
//  Created by Pritam on 15/9/21.
//

import RxSwift
import RxCocoa
import AppAuth
import NetworkPlatform

class AuthDataManager {
    var authState: OIDAuthState?
    
    func getAuthenticationRequest(completion: @escaping (OIDAuthorizationRequest?) -> Void) {
        self.getConfiguration { (configuration) in
            if let configuration = configuration {
                guard let redirectUri = URL(string: AuthConstants.redirectUri) else {
                    completion(nil)
                    return
                }

                let clientID = AuthConstants.clientId
                let clientSecret: String? = nil
                // builds authentication request
                let request = OIDAuthorizationRequest(configuration: configuration,
                                                      clientId: clientID,
                                                      clientSecret: clientSecret,
                                                      scopes: [OIDScopeOpenID, OIDScopeProfile],
                                                      redirectURL: redirectUri,
                                                      responseType: OIDResponseTypeCode,
                                                      additionalParameters: nil)
                completion(request)
            }
        }
    }
    
    func getConfiguration(completion: @escaping (OIDServiceConfiguration?) -> Void) {
        guard let issuer = URL(string: AuthConstants.issuer) else {
            log.debug("Error creating URL for : \(AuthConstants.issuer)")
            completion(nil)
            return
        }
        
        OIDAuthorizationService.discoverConfiguration(forIssuer: issuer) { configuration, error in
            guard let config = configuration else {
                log.debug("Error retrieving discovery document: \(error?.localizedDescription ?? "DEFAULT_ERROR")")
                completion(nil)
                return
            }
            log.debug("Got configuration: \(config)")
            
            completion(config)
        }
    }
    
    func getEndSessionRequest(completion: @escaping (OIDEndSessionRequest?) -> Void) {
        guard let issuer = URL(string: AuthConstants.issuer) else {
            log.debug("Error creating URL for : \(AuthConstants.issuer)")
            completion(nil)
            return
        }
        
        OIDAuthorizationService.discoverConfiguration(forIssuer: issuer) {[weak self] configuration, error in
            
            guard let configuration = configuration else {
                log.debug("Error retrieving discovery document: \(error?.localizedDescription ?? "DEFAULT_ERROR")")
                completion(nil)
                return
            }
            
            let authState = self?.getAuthState()
            
            guard let idToken = authState?.lastTokenResponse?.idToken else {
                completion(nil)
                return
            }
            
            guard let redirectUri = URL(string: AuthConstants.redirectUri) else {
                log.debug("Error creating URL for : \(AuthConstants.redirectUri)")
                completion(nil)
                return
            }
            
            let request = OIDEndSessionRequest(configuration: configuration,
                                               idTokenHint: idToken,
                                               postLogoutRedirectURL: redirectUri,
                                               additionalParameters: nil)
            completion(request)
        }
    }
    
    func doEndSessionApiCall(completion: @escaping (Bool) -> Void) {
        let authState = self.getAuthState()
        guard let endSessionEndpoint = authState?
                .lastAuthorizationResponse
                .request
                .configuration
                .discoveryDocument?
                .endSessionEndpoint else {
            log.debug("End session endpoint not declared in discovery document")
            completion(false)
            return
        }
        log.debug("End session endpoint: \(endSessionEndpoint.absoluteString)")
               
        guard let refressToken = authState?.lastTokenResponse?.refreshToken else {
            completion(false)
            return
        }
        
        let clientId = AuthConstants.clientId
        let clientSecret: String? = nil
        
        var urlRequest = URLRequest(url: endSessionEndpoint)
        urlRequest.allHTTPHeaderFields = ["content-type": "application/x-www-form-urlencoded"]
        urlRequest.httpMethod = "POST"
        
        var parameters: [String: Any] = [
            "client_id": clientId,
            "refresh_token": refressToken
        ]
        if let clientSecret = clientSecret {
            parameters["client_secret"] = clientSecret
        }
        
        urlRequest.httpBody = parameters.percentEncoded()

        let task = URLSession.shared.dataTask(with: urlRequest) {[weak self] _, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    log.debug("HTTP request failed \(error?.localizedDescription ?? "ERROR")")
                    completion(false)
                    return
                }

                guard let response = response as? HTTPURLResponse else {
                    log.debug("Non-HTTP response")
                    completion(false)
                    return
                }
                log.debug("HTTPURLResponse: \(response.statusCode)")
                
                if response.statusCode == HTTPStatusCodes.noContent.rawValue {
                    self?.saveAuthState(authState: nil)
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
        task.resume()
    }

    func saveAuthState(authState: OIDAuthState?) {
        self.authState = authState
        SessionManager.shared.writeAuthInfo(authState: authState)
    }

    func getAuthState() -> OIDAuthState? {
        return try? SessionManager.shared.loadAuthState()
    }
}
