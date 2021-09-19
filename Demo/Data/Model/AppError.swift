//
//  AppError.swift
//  Demo
//
//  Created by Pritam on 6/9/21.
//

import Foundation
import NetworkPlatform

struct AppError: Codable, Equatable {
    static func == (lhs: AppError, rhs: AppError) -> Bool {
        return lhs.type == rhs.type &&
            lhs.message == rhs.message
    }
    
    enum ErrorType: String, Codable {
        case unknown
        case network
        case server
        case sessionTimeout
        case assetNotFound
    }
    
    let tag: String
    let type: ErrorType
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case tag
        case type
        case message
    }
}

extension AppError {
    static let unknown = AppError(
        tag: "unknown",
        type: .unknown,
        message: "Unknown Error")
    
    static func getAppError(from apiError: ApiError?) -> AppError {
        guard let apiError = apiError else {
            let appError = AppError(
                tag: "Unknown",
                type: .unknown,
                message: "Unknown Error"
            )
            return appError
        }
        switch apiError {
        case .network(let tag):
            let appError = AppError(
                tag: tag,
                type: .network,
                message: "No Network"
            )
            return appError
        case .sessionTimeout(let tag):
            let appError = AppError(
                tag: tag,
                type: .sessionTimeout,
                message: "Unauthorized"
            )
            return appError
        case .serverError(let tag):
            let appError = AppError(
                tag: tag,
                type: .server,
                message: "Server Maintenance"
            )
            return appError
        case .serverResponse(let tag, let error):
            let appError = AppError(
                tag: tag,
                type: .server,
                message: error.message
            )
            return appError
        case .unknown(let tag),
             .notFound(let tag):
            let appError = AppError(
                tag: tag,
                type: .unknown,
                message: "Unknown Error"
            )
            return appError
        }
    }
}
