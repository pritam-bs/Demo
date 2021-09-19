//
//  HomeFlow.swift
//  Demo
//
//  Created by Pritam on 2/9/21.
//

import UIKit
import RxFlow
import NetworkPlatform

class HomeFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = false
        
        return navigationController
    }()
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        switch step {
        case .home:
            return navigationToHome()
        case .logout:
            return logout()
        default:
            return .none
        }
    }

    private func navigationToHome() -> FlowContributors {
        let networkUseCaseProvider = NetworkPlatform.UseCaseProvider()
        let userUseCase = networkUseCaseProvider.makeUserUseCase()
        let viewModel = HomeViewModel(userUseCase: userUseCase)
        let controller = HomeViewController.instantiate(
            withViewModel: viewModel
        )
        rootViewController.pushViewController(controller, animated: true)
        return FlowContributors.one(
            flowContributor: FlowContributor.contribute(
                withNextPresentable: controller,
                withNextStepper: viewModel
            )
        )
    }
    
    private func logout() -> FlowContributors {
        return FlowContributors.end(forwardToParentFlowWithStep: AppStep.logout)
    }
}
