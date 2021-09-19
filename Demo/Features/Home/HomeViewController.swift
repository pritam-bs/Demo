//
//  HomeViewController.swift
//  Demo
//
//  Created by Pritam on 3/9/21.
//

import UIKit
import Reusable
import RxCocoa
import RxSwift

class HomeViewController: UIViewController,
                          ViewType,
                          StoryboardSceneBased,
                          ActivityViewerType {
    var viewModel: HomeViewModel!
    
    static var sceneStoryboard = UIStoryboard(name: StoryboardScene.Initialization.storyboardName, bundle: nil)
    var reloadBarButtonItem = UIBarButtonItem(title: "Load", style: .plain, target: nil, action: nil)
    var logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: nil, action: nil)
    
    let disposeBag = DisposeBag()
    private var loginViewManager: AuthViewManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = reloadBarButtonItem
        navigationItem.leftBarButtonItem = logoutBarButtonItem
        setupLogoutAction()
        bindViewModel()
    }
    
    private func bindViewModel() {
        assert(viewModel != nil)
        buindActivityIndicator()
        bindErrorHandling()
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        let reload = reloadBarButtonItem.rx.tap.asDriver()
        
        let input = HomeViewModel.Input(
            trigger: Driver.merge(viewWillAppear, reload))
        let output = viewModel.transform(input: input)
        
        output.userInfo
            .asObservable()
            .bind { [weak self] userInfo in
                let userInfo = userInfo
            }.disposed(by: disposeBag)
        
    }
    
    private func setupLogoutAction() {
        loginViewManager = AuthViewManager(controller: self)
        logoutBarButtonItem.rx.tap.bind { [weak self] in
            self?.loginViewManager?.doEndSession(apiCall: false)
        }.disposed(by: disposeBag)
    }
}

extension HomeViewController: ErrorViewerType {
    func shouldShowErrorDialog(errorResponse: AppError) -> Bool {
        return true
    }
}

extension HomeViewController: AuthViewType {
    func loginCompletion(isSuccess: Bool, error: Error?) {
        
    }
    
    func logoutCompletion(isSuccess: Bool) {
          
    }
}
