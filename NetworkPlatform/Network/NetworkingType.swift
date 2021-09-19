//
//  NetworkingType.swift
//  NetworkPlatform
//
//  Created by Pritam on 9/9/21.
//

import Moya
import RxMoya
import RxSwift
import Alamofire
import AppAuth

protocol NetworkingType {
    associatedtype TargetType: Moya.TargetType, DemoApiType
    var provider: NetworkProvider<TargetType> { get }
    func request(_ token: TargetType) -> Observable<Moya.Response>
}

extension NetworkingType {
    func request(_ token: TargetType) -> Observable<Moya.Response> {
        return self.provider.request(token)
            .catch({ (error) -> Observable<Response> in
                guard let error = error as? MoyaError else { return .empty() }
                
                switch error {
                case .statusCode(let response):
                    if let error = getApiError(for: response.statusCode, response: response, token: token) {
                        return .error(error)
                    }
                    return .just(response)
                case .underlying(let error, let response):
                    let apiError = getApiError(for: error, response: response, token: token)
                    return .error(apiError)
                default:
                    return .error(ApiError.unknown(tag: token.requestTag))
                }
        })
    }
    
    private func getApiError(for statusCode: Int, response: Response?, token: DemoApiType) -> ApiError? {
        switch statusCode {
        case HTTPStatusCodes.unauthorized.rawValue:
            return ApiError.sessionTimeout(tag: token.requestTag)
        case HTTPStatusCodes.notFound.rawValue:
            return ApiError.notFound(tag: token.requestTag)
        case (HTTPStatusCodes.internalServerError.rawValue ...
                HTTPStatusCodes.networkAuthenticationRequired.rawValue):
            return ApiError.serverError(tag: token.requestTag)
        default:
            if let response = response,
               let decode = try? JSONDecoder()
                .decode(ServerError.self, from: response.data) {
                return ApiError.serverResponse(tag: token.requestTag, error: decode)
            } else {
                return nil
            }
        }
    }
    
    private func getApiError(for error: Error, response: Moya.Response?, token: DemoApiType) -> ApiError {
        if let statusCode = response?.statusCode,
           let error = getApiError(for: statusCode, response: response, token: token) {
            return error
        }
        
        if let afError = error as? AFError {
            if case let AFError.sessionTaskFailed(underlyingError) = afError {
                let nsError = underlyingError as NSError
                if nsError.code == NSURLErrorTimedOut {
                    return ApiError.network(tag: token.requestTag)
                }
            }
            
            if case let AFError.requestAdaptationFailed(underlyingError) = afError {
                
                let appAuthError = underlyingError as NSError
                if appAuthError.code == OIDErrorCodeOAuth.invalidGrant.rawValue {
                    return ApiError.sessionTimeout(tag: token.requestTag)
                }
                if appAuthError.code == OIDErrorCode.networkError.rawValue {
                    return ApiError.network(tag: token.requestTag)
                }
            }
        }
        return ApiError.unknown(tag: token.requestTag)
    }
}
