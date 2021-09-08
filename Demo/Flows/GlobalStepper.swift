//
//  GlobalStepper.swift
//  Demo
//
//  Created by Pritam on 8/9/21.
//

import RxFlow
import RxCocoa

class GlobalStepper: Stepper {
    static let shared = GlobalStepper()
    
    let steps = PublishRelay<Step>()
    
    private init() {
        
    }
    
    func logout() {
        steps.accept(AppStep.logout)
    }
}
