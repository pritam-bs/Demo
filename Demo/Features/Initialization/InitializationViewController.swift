//
//  InitializationViewController.swift
//  Demo
//
//  Created by Pritam on 3/9/21.
//

import UIKit
import Reusable
import RxSwift
import NVActivityIndicatorView
import NVActivityIndicatorViewExtended

class InitializationViewController: UIViewController,
                                    StoryboardSceneBased,
                                    ViewType,
                                    ActivityViewerType {
    
    var disposeBag = DisposeBag()
    var viewModel: InitializationViewModel!
    
    static var sceneStoryboard = UIStoryboard(name: StoryboardScene.Initialization.storyboardName, bundle: nil)
    
    override func viewDidLoad() {
        buindActivityIndicator()
        bindErrorHandling()
    }
    
    @IBAction func welcomeAction(_ sender: Any) {
        viewModel.navigateToWelcome()
    }
}

extension InitializationViewController: ErrorViewerType {
    func shouldShowErrorDialog(errorResponse: AppError, requestTag: String) -> Bool {
        return true
    }
}
