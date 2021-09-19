//
//  DemoApiType.swift
//  NetworkPlatform
//
//  Created by Pritam on 9/9/21.
//

import Foundation

protocol DemoApiType {
    var shouldSkipOnlineCheck: Bool { get }
    var requestTag: String { get }
}
