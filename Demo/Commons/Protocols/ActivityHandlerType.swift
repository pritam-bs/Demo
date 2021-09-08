//
//  ActivityProviderType.swift
//  Demo
//
//  Created by Pritam on 3/9/21.
//

import RxCocoa

protocol ActivityHandlerType {
    var activityIndicator: Driver<Bool> { get }
}
