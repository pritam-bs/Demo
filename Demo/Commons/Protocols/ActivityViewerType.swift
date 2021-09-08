//
//  ActivityViewerType.swift
//  Demo
//
//  Created by Pritam on 3/9/21.
//

import UIKit
import NVActivityIndicatorView
import NVActivityIndicatorViewExtended
import RxSwift
import RxCocoa

protocol ActivityViewerType: NVActivityIndicatorViewable {
    var disposeBag: DisposeBag { get }
    var activityBinding: Binder<Bool> { get }
}

extension ActivityViewerType where Self: UIViewController & ViewType {
    var activityBinding: Binder<Bool> {
        return Binder(self, binding: { (viewController, isLoading) in
            if isLoading {
                let size = CGSize(width: 44, height: 44)
                let indicatorType = NVActivityIndicatorType.circleStrokeSpin
                viewController.startAnimating(
                    size,
                    type: indicatorType,
                    color: UIColor.red,
                    backgroundColor: UIColor.clear
                )
            } else {
                viewController.stopAnimating()
            }
        })
    }
    
    func buindActivityIndicator() {
        if let viewModel = viewModel as? ActivityHandlerType {
            viewModel.activityIndicator
                .debug()
                .asDriver()
                .drive(activityBinding)
                .disposed(by: disposeBag)
        }
    }
}
