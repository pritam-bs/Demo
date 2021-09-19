//
//  WelcomeViewController.swift
//  Demo
//
//  Created by Pritam on 3/9/21.
//

import UIKit
import Reusable

class WelcomeViewController: UIViewController, ViewType, StoryboardSceneBased {
    
    var viewModel: WelcomeViewModel!
    
    static var sceneStoryboard = UIStoryboard(name: StoryboardScene.Initialization.storyboardName, bundle: nil)
    private var loginViewManager: AuthViewManager?
    
    override func viewDidLoad() {
        loginViewManager = AuthViewManager(controller: self)
    }
    
    @IBAction func signInAction(_ sender: Any) {
        self.loginViewManager?.doAuthWithAutoCodeExchange()
    }
    
    @IBAction func signOutAction(_ sender: Any) {
        self.loginViewManager?.doEndSession(apiCall: false)
    }
}

extension WelcomeViewController: AuthViewType {
    func loginCompletion(isSuccess: Bool, error: Error?) {
        if isSuccess {
            self.viewModel.navigateToHome()
        }
    }
    
    func logoutCompletion(isSuccess: Bool) {
        
    }
}
