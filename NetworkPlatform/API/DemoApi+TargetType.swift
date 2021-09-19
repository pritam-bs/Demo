//
//  DemoApi+TargetType.swift
//  NetworkPlatform
//
//  Created by Pritam on 9/9/21.
//

import Moya
import RxSwift

extension DemoApi: TargetType {
    var baseURL: URL {
        switch self {
        default:
        guard let url = URL(string: ApiConstants.apiURLString)
            else { fatalError("Failed to initialize URL.") }
        return url
        }
    }
    
    var path: String {
        switch self {
        case .userInfo:
            return "userinfo"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .userInfo:
            return .get
        }
    }
    
    var validationType: ValidationType {
        return .successAndRedirectCodes
    }
    
    var task: Task {
        switch self {
        default:
            return .requestPlain
        }
    }
    
    var contentType: String {
        switch self {
        default:
            return "application/json"
        }
    }
    
    var headers: [String: String]? {
        let headers = [
            "Accept": "*/*",
            "Accept-Encoding": "gzip, deflate, br",
            "Content-Type": contentType,
            "Device-Type": "SmartDevice",
            "x-device-platform": "IOS"
        ]
        return headers
    }
}

extension DemoApi: DemoApiType {
    var requestTag: String {
        switch self {
        case .userInfo:
            return "userInfo"
        }
    }
    
    var shouldSkipOnlineCheck: Bool {
        switch self {
        default:
            return false
        }
    }
}
