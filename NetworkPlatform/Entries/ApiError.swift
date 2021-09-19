//
//  ApiError.swift
//  Demo
//
//  Created by Pritam on 6/9/21.
//

import Domain

public struct ServerError: Codable {
    public let message: String
    
    enum CodingKeys: String, CodingKey {
        case message
    }
}

public enum ApiError: Error {
    case unknown(tag: String)
    case network(tag: String)
    case notFound(tag: String)
    case sessionTimeout(tag: String)
    case serverError(tag: String)
    case serverResponse(tag: String, error: ServerError)
}

extension ApiError: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let key = container.allKeys.first
        
        switch key {
        case .unknown:
            let tag = try container.decode(
                String.self,
                forKey: .unknown)
            self = .unknown(tag: tag)
        case .network:
            let tag = try container.decode(
                String.self,
                forKey: .network)
            self = .network(tag: tag)
        case .notFound:
            let tag = try container.decode(
                String.self,
                forKey: .notFound)
            self = .notFound(tag: tag)
        case .sessionTimeout:
            let tag = try container.decode(
                String.self,
                forKey: .sessionTimeout)
            self = .sessionTimeout(tag: tag)
        case .serverError:
            let tag = try container.decode(
                String.self,
                forKey: .serverError)
            self = .serverError(tag: tag)
        case .serverResponse:
            var nestedContainer = try container.nestedUnkeyedContainer(forKey: .serverResponse)
            let tag = try nestedContainer.decode(String.self)
            let error = try nestedContainer.decode(ServerError.self)
            self = .serverResponse(tag: tag, error: error)
        default:
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Unabled to decode enum."
                )
            )
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .unknown(let tag):
            try container.encode(tag, forKey: .unknown)
        case .network(let tag):
            try container.encode(tag, forKey: .network)
        case .notFound(let tag):
            try container.encode(tag, forKey: .notFound)
        case .sessionTimeout(let tag):
            try container.encode(tag, forKey: .sessionTimeout)
        case .serverError(let tag):
            try container.encode(tag, forKey: .serverError)
        case .serverResponse(let tag, let error):
            var nestedContainer = container.nestedUnkeyedContainer(forKey: .serverResponse)
            try nestedContainer.encode(tag)
            try nestedContainer.encode(error)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case unknown
        case network
        case notFound
        case sessionTimeout
        case serverError
        case serverResponse
    }
}
