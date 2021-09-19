//
//  ApiConstants.swift
//  NetworkPlatform
//
//  Created by Pritam on 9/9/21.
//

import Foundation

struct ApiConstants {
    static var baseURLString: String {
        #if ENV_DEBUG
        return "http://10.0.1.8:8080/auth/realms/myrealm/protocol/openid-connect"
        #else
        return "http://10.0.1.8:8080/auth/realms/myrealm/protocol/openid-connect"
        #endif
    }
    
    static var apiPath: String {
        return ""
    }
    
    static var apiURLString: String {
        return baseURLString + apiPath
    }
}
