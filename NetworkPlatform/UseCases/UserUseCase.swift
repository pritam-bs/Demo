//
//  UserUseCase.swift
//  NetworkPlatform
//
//  Created by Pritam on 11/9/21.
//

import Domain
import RxSwift
import Moya

class UserUseCase: Domain.UserUseCase {
    private let networkProvider: Networking

    public init() {
        networkProvider = Networking.shared
    }
    
    func userInfo() -> Observable<UserInfo?> {
        let response = networkProvider
            .request(.userInfo)
            .share()
        
        let successResponse = response
            .filterIsRequestSucceeded()
            .safeMap(UserInfo.self)
            .flatMap { (userInfo) -> Observable<UserInfo?> in
                return .just(userInfo)
            }
        return successResponse
    }
}
