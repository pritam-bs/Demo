//
//  Observable+Extensions.swift
//  Demo
//
//  Created by Pritam on 16/9/21.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType where Element == Bool {
    /// Boolean not operator
    public func not() -> Observable<Bool> {
        return self.map(!)
    }
    
}

extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
}

extension ObservableType {
    
    func catchErrorJustComplete() -> Observable<Element> {
        return `catch` { _ in
            return Observable.empty()
        }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            log.debug("Error: \(error)")
            return Driver.empty()
        }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
