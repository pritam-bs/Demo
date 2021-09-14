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
    private let networkProvider: NetworkProvider<DemoApi>

    public init() {
        networkProvider = Networking.shared.provider
    }
    
    func userInfo() -> Observable<Result<UserInfo?, Error>> {
        let response = networkProvider
            .request(.userInfo)
            .share()
        
        let successResponse = response
            .filterIsRequestSucceeded()
            .safeMap(UserInfo.self)
            .flatMap { (userInfo) -> Observable<Result<UserInfo?, Error>> in
                return .just(.success(userInfo))
            }
        
        let errorResposse = response
            .filterIsRequestFailed()
            .safeMap(ApiError.self)
            .flatMap { (apiError) ->  Observable<Result<UserInfo?, Error>> in
                let error: ApiError = apiError ?? ApiError.unknown
                return .just(.failure(error))
            }
        
        return Observable.merge(successResponse, errorResposse)
        
    }
}
