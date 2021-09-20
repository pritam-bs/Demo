//
//  SceneDelegate.swift
//  Demo
//
//  Created by Pritam on 12/8/21.
//

import UIKit
import RxFlow
import RxSwift
import SwiftyBeaver
import AppAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let disposeBag = DisposeBag()
    var flowCoordinator = FlowCoordinator()
    var appFlow: AppFlow!
    var currentAuthorizationFlow: OIDExternalUserAgentSession?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        guard let window = window else { return }
        window.backgroundColor = .white
        
        SwiftyBeaver.initLog()
        
        appFlow = AppFlow(window: window)
        flowCoordinator.rx.didNavigate
            .subscribe(onNext: { (flow, step) in
                log.debug("[FlowCoordinator] App has been navigated.\n  Flow: \(flow)\n  Step: \(step)")
            })
            .disposed(by: disposeBag)
        let compositeStepper = CompositeStepper(
            steppers: [OneStepper(withSingleStep: AppStep.initialization)]
        )
        flowCoordinator.coordinate(flow: appFlow, with: compositeStepper)
        
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            if let url = userActivity.webpageURL {
                _ = handleDeepLinkUrl(url)
            }
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        _ = handleDeepLinkUrl(URLContexts.first?.url)
    }
}

extension SceneDelegate {
    func handleDeepLinkUrl(_ url: URL?) -> Bool {
        guard let url = url else { return false }
        if let authorizationFlow = self.currentAuthorizationFlow,
           authorizationFlow.resumeExternalUserAgentFlow(with: url) {
            self.currentAuthorizationFlow = nil
            return true
        }

        return false
    }
}
