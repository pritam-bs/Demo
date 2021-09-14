//
//  DemoApi+Stub.swift
//  NetworkPlatform
//
//  Created by Pritam on 9/9/21.
//

import Moya

extension DemoApi {
    static var stubEndpointClosure = { (target: DemoApi) -> Endpoint in
        var statusCode = 200
        switch target {
        default:
            break
        }

        return Endpoint(
            url: URL(target: target).absoluteString,
            sampleResponseClosure: { .networkResponse(statusCode, target.sampleData) },
            method: target.method,
            task: target.task,
            httpHeaderFields:
            target.headers
        )
    }
}
