//
//  UserInfo.swift
//  Domain
//
//  Created by Pritam on 8/9/21.
//

import Foundation

public struct UserInfo: Codable {
    public let email: String
    public let name: String
    public let phone: String
    public let uid: String
    public let username: String
    public let website: String

    public init(email: String,
                name: String,
                phone: String,
                uid: String,
                username: String,
                website: String) {
        self.email = email
        self.name = name
        self.phone = phone
        self.uid = uid
        self.username = username
        self.website = website
    }

    private enum CodingKeys: String, CodingKey {
        case email
        case name
        case phone
        case uid
        case username
        case website
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        email = try container.decode(String.self, forKey: .email)
        name = try container.decode(String.self, forKey: .name)
        phone = try container.decode(String.self, forKey: .phone)
        username = try container.decode(String.self, forKey: .username)
        website = try container.decode(String.self, forKey: .website)

        if let uid = try container.decodeIfPresent(Int.self, forKey: .uid) {
            self.uid = "\(uid)"
        } else {
            uid = try container.decodeIfPresent(String.self, forKey: .uid) ?? ""
        }
    }
}
