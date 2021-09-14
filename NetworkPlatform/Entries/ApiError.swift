//
//  ApiError.swift
//  Demo
//
//  Created by Pritam on 6/9/21.
//

import Domain

struct ServerError: Codable {
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case message
    }
}

enum ApiError: Error {
    case unknown
    case network
    case notFound
    case sessionTimeout
    case serverError
    case serverResponse(error: ServerError)
}

extension ApiError: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let key = container.allKeys.first
        
        switch key {
        case .unknown:
            self = .unknown
        case .network:
            self = .network
        case .notFound:
            self = .notFound
        case .sessionTimeout:
            self = .sessionTimeout
        case .serverError:
            self = .serverError
        case .serverResponse:
            let error = try container.decode(
                ServerError.self,
                forKey: .serverResponse
            )
            self = .serverResponse(error: error)
        default:
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Unabled to decode enum."
                )
            )
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .unknown:
            try container.encode(true, forKey: .unknown)
        case .network:
            try container.encode(true, forKey: .network)
        case .notFound:
            try container.encode(true, forKey: .notFound)
        case .sessionTimeout:
            try container.encode(true, forKey: .sessionTimeout)
        case .serverError:
            try container.encode(true, forKey: .serverError)
        case .serverResponse(let error):
            try container.encode(error, forKey: .serverResponse)
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
