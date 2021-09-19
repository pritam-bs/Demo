//
//  UseCaseProvider.swift
//  NetworkPlatform
//
//  Created by Pritam on 11/9/21.
//

import Domain

public class UseCaseProvider: Domain.UseCaseProvider {
    
    public init() {
        
    }
    
    public func makeUserUseCase() -> Domain.UserUseCase {
        return UserUseCase()
    }
}
