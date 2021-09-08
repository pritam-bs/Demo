//
//  AppError.swift
//  Demo
//
//  Created by Pritam on 6/9/21.
//

import Foundation

struct AppError: Codable, Equatable {
    static func == (lhs: AppError, rhs: AppError) -> Bool {
        return lhs.type == rhs.type &&
            lhs.message == rhs.message
    }
    
    enum ErrorType: String, Codable {
        case unknown
        case network
        case assetNotFound
    }
    
    let type: ErrorType
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case type
        case message
    }
    
    static var unknown = AppError(
        type: .unknown,
        message: "Unknown Error"
    )
    
    static var sessionBroken = AppError(
        type: .network,
        message: "Unauthorized"
    )

    static var networkError = AppError(
        type: .network,
        message: "No Network"
    )
    
    static var assetNotFoundError = AppError(
        type: .assetNotFound,
        message: "Asset Not Found"
    )
}
