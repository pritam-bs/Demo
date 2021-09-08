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
    func shouldShowErrorDialog(errorResponse: AppError, requestTag: String) -> Bool
    func shouldEnableRetry(errorResponse: AppError, requestTag: String) -> Bool
    func retryAction(errorResponse: AppError, requestTag: String)
    func okAction(errorResponse: AppError, requestTag: String)
    func handleSessionTimeout()
    func bindErrorHandling()
}

extension ErrorViewerType {
    func shouldEnableRetry(errorResponse: AppError, requestTag: String) -> Bool {
        return false
    }
    
    func retryAction(errorResponse: AppError, requestTag: String) {}
    
    func okAction(errorResponse: AppError, requestTag: String) {}
}

extension ErrorViewerType where Self: UIViewController & ViewType {
    var errorBinding: Binder<(errorResponse: AppError, requestTag: String)> {
        return Binder(self) { (viewController, errorObj) in
            if errorObj.errorResponse == .sessionBroken {
                viewController.handleSessionTimeout()
            } else if viewController.shouldShowErrorDialog(
                        errorResponse: errorObj.errorResponse,
                        requestTag: errorObj.requestTag) {
                let alertController = viewController.makeErrorAlert(
                    errorResponse: errorObj.errorResponse,
                    requestTag: errorObj.requestTag)
                viewController.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func bindErrorHandling() {
        if let viewModel = viewModel as? ErrorHandlerType {
            viewModel.errorResponse
                .asDriver(onErrorJustReturn: (
                            errorResponse: AppError.unknown,
                            requestTag: "unknown"))
                .drive(errorBinding)
                .disposed(by: disposeBag)
        }
    }
    
    func makeErrorAlert(errorResponse: AppError, requestTag: String) -> UIAlertController {
        let alertController = UIAlertController()
        switch errorResponse {
        case .networkError:
            alertController.title = L10n.Error.networkErrorTitle
            alertController.message = L10n.Error.networkErrorMessage
        case .assetNotFoundError:
            alertController.title = L10n.Error.assetNotFoundErrorTitle
            alertController.message = L10n.Error.assetNotFoundErrorMessage
        case .unknown:
            alertController.title = L10n.Error.unknownErrorTitle
            alertController.message = L10n.Error.unknownErrorMessage
        default:
            alertController.title = L10n.Error.loadingErrorTitle
            alertController.message = errorResponse.message.isEmpty ?
                L10n.Error.loadingErrorMessage :
                errorResponse.message
        }
        
        let okAction = UIAlertAction(
            title: L10n.Common.ok,
            style: .default) { [weak self] _ in
            self?.okAction(errorResponse: errorResponse, requestTag: requestTag)
        }
        alertController.addAction(okAction)
        
        if shouldEnableRetry(errorResponse: errorResponse, requestTag: requestTag) {
            let retryAction = UIAlertAction(
                title: L10n.Common.retry,
                style: .default) { [weak self] _ in
                self?.retryAction(errorResponse: errorResponse, requestTag: requestTag)
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
