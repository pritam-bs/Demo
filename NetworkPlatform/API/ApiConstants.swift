//
//  ApiConstants.swift
//  NetworkPlatform
//
//  Created by Pritam on 9/9/21.
//

import Foundation

struct ApiConstants {
//    static var baseURLString: String {
//        #if ENV_DEBUG
//        return "http://10.0.1.8:8080/auth/realms/myrealm/protocol/openid-connect"
//        #else
//        return "http://10.0.1.8:8080/auth/realms/myrealm/protocol/openid-connect"
//        #endif
//    }
    
    static var baseURLString: String {
        #if ENV_DEBUG
        return "https://jp-tok.appid.cloud.ibm.com/oauth/v4/6cc10eac-0c20-4d5b-834d-7801c7f20565"
        #else
        return "https://jp-tok.appid.cloud.ibm.com/oauth/v4/6cc10eac-0c20-4d5b-834d-7801c7f20565"
        #endif
    }
    
    static var apiPath: String {
        return ""
    }
    
    static var apiURLString: String {
        return baseURLString + apiPath
    }
}
