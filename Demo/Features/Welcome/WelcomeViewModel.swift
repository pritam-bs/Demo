//
//  WelcomeViewModel.swift
//  Demo
//
//  Created by Pritam on 3/9/21.
//

import RxFlow
import RxCocoa

class WelcomeViewModel: ViewModelType, Stepper {
    var steps =  PublishRelay<Step>()
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
    func navigateToHome() {
        steps.accept(AppStep.completeWelcome)
    }
}
