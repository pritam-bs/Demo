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
        return "https://bbra-customer.dev.gxp.jp"
        #else
        return "https://api.remote.bpfservice.jp"
        #endif
    }
    
    static var apiPath: String {
        return ""
    }
    
    static var apiURLString: String {
        return baseURLString + apiPath
    }
}
