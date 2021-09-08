//
//  InitializationFlow.swift
//  Demo
//
//  Created by Pritam on 2/9/21.
//

import UIKit
import RxFlow
import RxSwift

class InitializationFlow: Flow {
    var root: Presentable { return rootViewController }
    
    private lazy var rootViewController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        return navigationController
    }()
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        switch step {
        case .initialization:
            return navigateToInitialization()
        case .completeInitialization (let next):
            return completeInitialization(next: next)
        default:
            return .none
        }
    }
    
    private func navigateToInitialization() -> FlowContributors {
        let appStateService = AppStateService()
        let viewModel = InitializationViewModel()
        let controller = InitializationViewController.instantiate(
            withViewModel: viewModel,
            andServices: appStateService
        )
        rootViewController.pushViewController(controller, animated: true)
        return FlowContributors.one(
            flowContributor: FlowContributor.contribute(
                withNextPresentable: controller,
                withNextStepper: viewModel
            )
        )
    }

    private func completeInitialization(next: NextToInitialization) -> FlowContributors {
        return FlowContributors.end(forwardToParentFlowWithStep: AppStep.completeInitialization(next: next))
    }
}
