//
//  AppStep.swift
//  Demo
//
//  Created by Pritam on 2/9/21.
//

import RxFlow

enum AppStep: Step {
    case initialization
    
    case completeInitialization(next: NextToInitialization)
    
    case welcome
    
    case completeWelcome
    
    case registration
    
    case completeRegistration
    
    case home
    
    case logout
}

enum NextToInitialization {
    case home
    case welcome
}
