//
//  AuthConstants.swift
//  Demo
//
//  Created by Pritam on 15/9/21.
//

import Foundation

struct AuthConstants {
    static var issuer: String {
        #if ENV_DEBUG
        return "http://10.0.1.8:8080/auth/realms/myrealm"
        #else
        return "http://10.0.1.8:8080/auth/realms/myrealm"
        #endif
    }
    
    static var clientId: String {
        #if ENV_DEBUG
        return "myclient"
        #else
        return "myclient"
        #endif
    }
    
    static var redirectUri: String {
        #if ENV_DEBUG
        return "com.mlbd.demo.ca93ef15-1572-4a61-ba49-b17bb901d9ae://authredirect"
        #else
        return "com.mlbd.demo.ca93ef15-1572-4a61-ba49-b17bb901d9ae://authredirect"
        #endif
    }
}
