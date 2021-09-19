//
//  UserInfo.swift
//  Domain
//
//  Created by Pritam on 8/9/21.
//

import Foundation

// MARK: - UserInfo
public struct UserInfo: Codable {
    let sub: String
    let emailVerified: Bool
    let name, preferredUsername, givenName, familyName: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case sub
        case emailVerified = "email_verified"
        case name
        case preferredUsername = "preferred_username"
        case givenName = "given_name"
        case familyName = "family_name"
        case email
    }
}
