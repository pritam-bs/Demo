//
//  Networking.swift
//  NetworkPlatform
//
//  Created by Pritam on 11/9/21.
//

import Moya
import RxMoya
import Reachability
import RxReachability

class Networking: NetworkingType {
    let provider: NetworkProvider<DemoApi>
    
    #if API_STUB
    static let shared = Networking(isStubbed: true)
    #else
    static let shared = Networking()
    static let sharedWithoutCredentials = Networking(isWithCredentials: false)
    #endif
    #if DEBUG
    static let stubbed = Networking(isStubbed: true)
    #endif
    
    init(isStubbed: Bool = false, isWithCredentials: Bool = true) {
        var plugins: [PluginType] = []
        #if DEBUG
        var loggerPluginConfiguration = NetworkLoggerPlugin.Configuration()
        loggerPluginConfiguration.logOptions = .formatRequestAscURL
        plugins.append(NetworkLoggerPlugin(configuration: loggerPluginConfiguration))
        #endif
        provider = NetworkProvider(
            endpointClosure: DemoApi.stubEndpointClosure,
            stubClosure: isStubbed ? MoyaProvider.immediatelyStub : MoyaProvider.neverStub,
            session: isWithCredentials ? SessionManager.shared.session :
                SessionManager.shared.sessionWithoutCredentials,
            plugins: plugins,
            networkStatus: isStubbed ? .just(true) : Reachability.rx.isReachable
        )
    }
}
