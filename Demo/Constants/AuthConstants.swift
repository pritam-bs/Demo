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

    static var clientSecret: String? {
        #if ENV_DEBUG
        return nil
        #else
        return nil
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

//struct AuthConstants {
//    static var issuer: String {
//        #if ENV_DEBUG
//        return "https://jp-tok.appid.cloud.ibm.com/oauth/v4/6cc10eac-0c20-4d5b-834d-7801c7f20565"
//        #else
//        return "https://jp-tok.appid.cloud.ibm.com/oauth/v4/6cc10eac-0c20-4d5b-834d-7801c7f20565"
//        #endif
//    }
//
//    static var clientId: String {
//        #if ENV_DEBUG
//        return "fd921de1-5d88-417f-86b8-73bf850eef51"
//        #else
//        return "fd921de1-5d88-417f-86b8-73bf850eef51"
//        #endif
//    }
//
//    static var clientSecret: String {
//        #if ENV_DEBUG
//        return "MjdjNDhjNmEtMzJiNC00YjU3LWFmMTUtYjBmMDI1MGU0MGZj"
//        #else
//        return "MjdjNDhjNmEtMzJiNC00YjU3LWFmMTUtYjBmMDI1MGU0MGZj"
//        #endif
//    }
//
//    static var redirectUri: String {
//        #if ENV_DEBUG
//        return "https://mlbd-serverless.web.app/authredirect"
//        #else
//        return "https://mlbd-serverless.web.app/authredirect"
//        #endif
//    }
//}
