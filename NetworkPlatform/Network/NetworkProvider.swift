//
//  NetworkProvider.swift
//  NetworkPlatform
//
//  Created by Pritam on 9/9/21.
//

import Moya
import RxMoya
import RxSwift

class NetworkProvider<Target> where Target: Moya.TargetType {
    private let provider: MoyaProvider<Target>
    private let networkStatus: Observable<Bool>
    
    init(endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider<Target>.defaultEndpointMapping,
         stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
         session: Session = MoyaProvider<Target>.defaultAlamofireSession(),
         plugins: [PluginType] = [],
         trackInflights: Bool = false,
         networkStatus: Observable<Bool>) {
        self.networkStatus = networkStatus
        provider = MoyaProvider(
            endpointClosure: endpointClosure,
            requestClosure: requestClosure,
            stubClosure: stubClosure,
            session: session,
            plugins: plugins,
            trackInflights: trackInflights
        )
    }
    
    private let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            request.timeoutInterval = 10.0
            done(.success(request))
        } catch {
            done(.failure(MoyaError.underlying(error, nil)))
        }
    }
    
    func request(_ token: Target) -> Observable<Moya.Response> {
        guard let demoApiToken = token as? DemoApiType else {
            fatalError("Unknown API token")
        }
        
        let actual = provider.rx.request(token)
        
        if demoApiToken.shouldSkipOnlineCheck {
            return requestNotRequiredOnline(actualRequest: actual)
        } else {
            return requestRequiredOnline(actualRequest: actual)
        }
    }
    
    private func requestNotRequiredOnline(
        actualRequest: Single<Response>
    ) -> Observable<Moya.Response> {
        return actualRequest.asObservable()
    }
    
    private func requestRequiredOnline(
        actualRequest: Single<Response>
    ) -> Observable<Moya.Response> {
        return networkStatus
            .filter { $0 }
            .take(1)
            .flatMap { _ in return actualRequest }
    }
}
