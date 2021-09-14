//
//  NetworkingType.swift
//  NetworkPlatform
//
//  Created by Pritam on 9/9/21.
//

import Moya
import RxMoya
import RxSwift

protocol NetworkingType {
    associatedtype TargetType: Moya.TargetType, DemoApiType
    var provider: NetworkProvider<TargetType> { get }
    func request(_ token: TargetType) -> Observable<Moya.Response>
}

extension NetworkingType {
    func request(_ token: TargetType) -> Observable<Moya.Response> {
        return self.provider.request(token)
            .catch({ (error) -> Observable<Response> in
                
                func getApiError(for statusCode: Int, response: Response?) -> ApiError? {
                    switch statusCode {
                    case HTTPStatusCodes.unauthorized.rawValue:
                        return ApiError.sessionTimeout
                    case HTTPStatusCodes.notFound.rawValue:
                        return ApiError.notFound
                    case (HTTPStatusCodes.internalServerError.rawValue ...
                            HTTPStatusCodes.networkAuthenticationRequired.rawValue):
                        return ApiError.serverError
                    default:
                        if let response = response,
                           let decode = try? JSONDecoder()
                            .decode(ServerError.self, from: response.data) {
                            return ApiError.serverResponse(error: decode)
                        } else {
                            return nil
                        }
                    }
                }
                
                func encodedApiError(statusCode: Int, apiError: ApiError) -> Observable<Response> {
                    if let encoded = try? JSONEncoder().encode(apiError) {
                        let response = Response(statusCode: statusCode, data: encoded)
                        return .just(response)
                    } else {
                        return .empty()
                    }
                }
                
                guard let error = error as? MoyaError else { return .empty() }
                
                switch error {
                case .statusCode(let response):
                    if let error = getApiError(for: response.statusCode, response: response) {
                        return encodedApiError(statusCode: response.statusCode, apiError: error)
                    }
                    return .just(response)
                case .underlying(let error, let response):
                    if let statusCode = response?.statusCode,
                       let error = getApiError(for: statusCode, response: response) {
                        return encodedApiError(statusCode: statusCode, apiError: error)
                    }
                    
                    if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                        return encodedApiError(statusCode: urlError.code.rawValue, apiError: ApiError.network)
                    }
                    
                    let nsError = error as NSError
                    return encodedApiError(statusCode: nsError.code, apiError: .unknown)
                default:
                    return encodedApiError(statusCode: error.errorCode, apiError: .unknown)
                }
        })
    }
}
