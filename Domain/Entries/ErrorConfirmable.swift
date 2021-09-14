//
//  AppError.swift
//  Domain
//
//  Created by Pritam on 12/9/21.
//

import Foundation

public protocol ErrorConfirmable {
    associatedtype ErrorType
    var type: ErrorType { get }
    var message: String { get }
}
