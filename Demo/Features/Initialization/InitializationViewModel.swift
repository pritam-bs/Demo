//
//  InitializationViewModel.swift
//  Demo
//
//  Created by Pritam on 3/9/21.
//

import RxFlow
import RxCocoa

class InitializationViewModel: ServicesViewModelType,
                               Stepper,
                               ActivityHandlerType,
                               ErrorHandlerType {
    var errorResponse = PublishRelay<(errorResponse: AppError, requestTag: String)>()
    
    private let apiLoading = ActivityIndicator()
    private let otherLoading = PublishRelay<ActivityIndicator.Element>()
    var activityIndicator: Driver<Bool> {
        let activityIndicator = Driver.merge(
            otherLoading.asDriver(onErrorJustReturn: false),
            apiLoading.asDriver())
        return activityIndicator
    }
    var steps =  PublishRelay<Step>()
    var services: AppStateService!
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    init() {
        
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}

extension InitializationViewModel {
    func navigateToWelcome() {
        self.steps.accept(AppStep.completeInitialization(next: NextToInitialization.welcome))
    }
}
