//
//  Observable+Extensions.swift
//  NetworkPlatform
//
//  Created by Pritam on 12/9/21.
//

import RxSwift
import Moya

extension Observable where Element: Response {
    func filterIsRequestSucceeded() -> Observable<Element> {
        return filter { (element) -> Bool in
            return (200...299).contains(element.statusCode)
        }
    }
    
    func filterIsRequestFailed() -> Observable<Element> {
        return filter { return !(100...399).contains($0.statusCode) }
    }
    
    func safeMap<T: Decodable>(_ type: T.Type) -> Observable<T?> {
        return map { (element) -> T? in
            if let str = String(data: element.data, encoding: .utf8) {
                log.debug(str)
            }
            do {
                return try JSONDecoder().decode(type, from: element.data)
            } catch {
                log.error("Failed to map response. error: \(error)")
                return nil
            }
        }
    }
}
