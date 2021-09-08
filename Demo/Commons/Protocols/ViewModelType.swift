//
//  ViewModelType.swift
//  Demo
//
//  Created by Pritam on 2/9/21.
//

import RxSwift
import RxCocoa
import Reusable
import RxFlow

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

extension ViewModelType where Self: Stepper {
    func logout() {
        steps.accept(AppStep.logout)
    }
}

protocol ServicesViewModelType: ViewModelType {
    associatedtype Services
    var services: Services! { get set }
}
