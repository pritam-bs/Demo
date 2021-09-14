//
//  UseCaseProvider.swift
//  NetworkPlatform
//
//  Created by Pritam on 11/9/21.
//

import Domain

class UseCaseProvider: Domain.UseCaseProvider {
    func makeUserUseCase() -> Domain.UserUseCase {
        return UserUseCase()
    }
}
