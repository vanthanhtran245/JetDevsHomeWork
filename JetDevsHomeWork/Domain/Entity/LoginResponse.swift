//
//  LoginResponse.swift
//  JetDevsHomeWork
//
//  Created by er-thanhtv on 12/7/22.
//

import Foundation

struct LoginResponse: BaseResponse, Codable {
    typealias T = UserInformation
    var result: Int
    var errorMessage: String
    var data: UserInformation
}

struct UserInformation: Codable {
    let user: User
}

// MARK: - User
struct User: Codable {
    let userID: Int
    let userName: String
    let userProfileURL: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case userName = "user_name"
        case userProfileURL = "user_profile_url"
        case createdAt = "created_at"
    }
}
