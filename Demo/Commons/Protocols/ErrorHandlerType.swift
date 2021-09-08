//
//  ErrorProviderType.swift
//  Demo
//
//  Created by Pritam on 3/9/21.
//

import RxCocoa

protocol ErrorHandlerType {
    var errorResponse: PublishRelay<(errorResponse: AppError, requestTag: String)> { get }
    func handleSessionTimeout()
}

extension ErrorHandlerType {
    func handleSessionTimeout() {
        let appStateService = AppStateService()
        appStateService.clearUserInfo()
        appStateService.clearSessionInfo()
        GlobalStepper.shared.logout()
    }
}
