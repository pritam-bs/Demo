//
//  ErrorViewerType.swift
//  Demo
//
//  Created by Pritam on 3/9/21.
//

import UIKit
import RxSwift

protocol ErrorViewerType {
    var disposeBag: DisposeBag { get }
    func shouldShowErrorDialog(errorResponse: AppError) -> Bool
    func shouldEnableRetry(errorResponse: AppError) -> Bool
    func retryAction(errorResponse: AppError)
    func okAction(errorResponse: AppError)
    func handleSessionTimeout()
    func bindErrorHandling()
}

extension ErrorViewerType {
    func shouldEnableRetry(errorResponse: AppError) -> Bool {
        return false
    }
    
    func retryAction(errorResponse: AppError) {}
    
    func okAction(errorResponse: AppError) {}
}

extension ErrorViewerType where Self: UIViewController & ViewType {
    var errorBinding: Binder<AppError> {
        return Binder(self) { (viewController, appError) in
            if appError.type == .sessionTimeout {
                viewController.handleSessionTimeout()
            } else if viewController.shouldShowErrorDialog(
                        errorResponse: appError) {
                let alertController = viewController.makeErrorAlert(
                    appError: appError)
                viewController.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func bindErrorHandling() {
        if let viewModel = viewModel as? ErrorHandlerType {
            viewModel.errorResponse
                .asDriver(onErrorJustReturn: AppError.unknown)
                .drive(errorBinding)
                .disposed(by: disposeBag)
        }
    }
    
    func makeErrorAlert(appError: AppError) -> UIAlertController {
        let alertController = UIAlertController()
        switch appError.type {
        case .network:
            alertController.title = L10n.Error.networkErrorTitle
            alertController.message = L10n.Error.networkErrorMessage
        case .assetNotFound:
            alertController.title = L10n.Error.assetNotFoundErrorTitle
            alertController.message = L10n.Error.assetNotFoundErrorMessage
        case .unknown:
            alertController.title = L10n.Error.unknownErrorTitle
            alertController.message = L10n.Error.unknownErrorMessage
        default:
            alertController.title = L10n.Error.loadingErrorTitle
            alertController.message = appError.message.isEmpty ?
                L10n.Error.loadingErrorMessage :
                appError.message
        }
        
        let okAction = UIAlertAction(
            title: L10n.Common.ok,
            style: .default) { [weak self] _ in
            self?.okAction(errorResponse: appError)
        }
        alertController.addAction(okAction)
        
        if shouldEnableRetry(errorResponse: appError) {
            let retryAction = UIAlertAction(
                title: L10n.Common.retry,
                style: .default) { [weak self] _ in
                self?.retryAction(errorResponse: appError)
            }
            alertController.addAction(retryAction)
        }
        
        return alertController
    }
    
    func handleSessionTimeout() {
        let alertController = UIAlertController()
        alertController.title = L10n.Error.sessionTimeoutTitle
        alertController.message = L10n.Error.sessionTimeoutMessage
        
        let okAction = UIAlertAction(
            title: L10n.Common.ok,
            style: .default) { [weak self] _ in
            if let viewModel = self?.viewModel as? ErrorHandlerType {
                viewModel.handleSessionTimeout()
            }
        }
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
