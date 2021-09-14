//
//  ViewType.swift
//  Demo
//
//  Created by Pritam on 2/9/21.
//

import UIKit
import Reusable

protocol ViewType: AnyObject {
    associatedtype ViewModel: ViewModelType
    var viewModel: ViewModel! { get set }
}

extension ViewType where Self: StoryboardSceneBased & UIViewController {
    static func instantiate<ViewModel>(
        withViewModel viewModel: ViewModel) -> Self
    where ViewModel == Self.ViewModel {
        let viewController = Self.instantiate()
        viewController.viewModel = viewModel
        return viewController
    }
}

extension ViewType where Self: StoryboardSceneBased & UIViewController,
                         ViewModel: ServicesViewModelType {
    static func instantiate<ViewModel, Services>(
        withViewModel viewModel: ViewModel,
        andServices services: Services) -> Self
    where ViewModel == Self.ViewModel,
          Services == Self.ViewModel.Services {
        let viewController = Self.instantiate()
        viewController.viewModel = viewModel
        viewController.viewModel.services = services
        return viewController
    }
}
