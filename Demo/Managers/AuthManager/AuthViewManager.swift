//
//  AuthViewManager.swift
//  Demo
//
//  Created by Pritam on 15/9/21.
//

import UIKit
import AppAuth

class AuthViewManager: NSObject {
    private let dataManager = AuthDataManager()
    weak private var controller: AuthViewType?
    private var authState: OIDAuthState?
    
    init(controller: AuthViewType) {
        super.init()
        self.controller = controller
    }
    
    func doAuthWithAutoCodeExchange() {
        self.setAuthState(authState: nil)
        self.dataManager.getAuthenticationRequest { (request) in
            guard let request = request else { return }
            // performs authentication request
            log.debug("Initiating authorization request with scope: \(request.scope ?? "DEFAULT_SCOPE")")

            guard let sceneDelegate = self.controller?.view.window?.windowScene?.delegate as? SceneDelegate else {
                log.debug("Error accessing AppDelegate")
                return
            }
            
            guard let controller = self.controller else {
                log.debug("Error accessing view controller")
                return
            }
            
            guard let userAgent = OIDExternalUserAgentIOS(presenting: controller) else {
                return
            }
            
            //let userAgent = OIDExternalUserAgentIOSSafari(presentingViewController: controller)
            
            sceneDelegate.currentAuthorizationFlow = OIDAuthState.authState(
                byPresenting: request,
                externalUserAgent: userAgent) { [weak self]  authState, error in

                if let authState = authState {
                    self?.dataManager.authState = authState
                    log.debug("Got authorization tokens. Access token: " +
                              "\(String(describing: authState.lastTokenResponse?.accessToken))")
                    log.debug("Got authorization tokens. Refresh token: " +
                                "\(String(describing: authState.lastTokenResponse?.refreshToken))")
                    self?.setAuthState(authState: authState)
                    self?.controller?.loginCompletion(isSuccess: true, error: nil)
                } else {
                    log.debug("Authorization error: \(error?.localizedDescription ?? "DEFAULT_ERROR")")
                    self?.setAuthState(authState: nil)
                    self?.controller?.loginCompletion(isSuccess: false, error: error)
                }
            }
        }
    }
    
    func doEndSession(apiCall: Bool = true) {
        if apiCall {
            self.dataManager.doEndSessionApiCall { [weak self] (isSuccess) in
                self?.controller?.logoutCompletion(isSuccess: isSuccess)
            }
        } else {
            self.dataManager.getEndSessionRequest { [weak self] (request) in
                guard let request = request else {
                    self?.controller?.logoutCompletion(isSuccess: false)
                    return
                }
                
                guard let sceneDelegate = self?.controller?.view.window?.windowScene?.delegate as? SceneDelegate else {
                    self?.controller?.logoutCompletion(isSuccess: false)
                    return
                }
                
                guard let controller = self?.controller else {
                    log.debug("Error accessing view controller")
                    self?.controller?.logoutCompletion(isSuccess: false)
                    return
                }
                
                guard let userAgent = OIDExternalUserAgentIOS(presenting: controller) else {
                    self?.controller?.logoutCompletion(isSuccess: false)
                    return
                }
                
                sceneDelegate.currentAuthorizationFlow =
                    OIDAuthorizationService
                        .present(request,
                                 externalUserAgent: userAgent,
                                 callback: { [weak self] ( _, error ) in
                                    if let error = error {
                                        log.debug("End session error: \(error)")
                                        self?.controller?.logoutCompletion(isSuccess: false)
                                    } else {
                                        self?.setAuthState(authState: nil)
                                        self?.controller?.logoutCompletion(isSuccess: true)
                                    }
                    })
            }
        }
    }

    private func loadState() {
        if let authState = self.dataManager.getAuthState() {
            self.setAuthState(authState: authState)
        }
    }

    private func setAuthState(authState: OIDAuthState?) {
        if self.authState == authState {
            return
        }
        self.authState = authState
        self.authState?.stateChangeDelegate = self
        self.dataManager.saveAuthState(authState: authState)
    }
}

// MARK: OIDAuthState Delegate
extension AuthViewManager: OIDAuthStateChangeDelegate, OIDAuthStateErrorDelegate {

    func didChange(_ state: OIDAuthState) {
        self.dataManager.saveAuthState(authState: state)
    }

    func authState(_ state: OIDAuthState, didEncounterAuthorizationError error: Error) {
        log.debug("Received authorization error: \(error)")
    }
}
