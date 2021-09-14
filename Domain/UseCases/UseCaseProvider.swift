//
//  UseCaseProvider.swift
//  Domain
//
//  Created by Pritam on 9/9/21.
//

import Foundation

public protocol UseCaseProvider {
    func makeUserUseCase() -> UserUseCase
}
