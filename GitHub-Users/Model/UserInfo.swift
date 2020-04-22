//
//  UserInfo.swift
//  GitHub-Users
//
//  Created by Cong Le on 4/22/20.
//  Copyright © 2020 CongLeSolutionX. All rights reserved.
//

import Foundation

struct UserInfo: Codable{
    let login: String?
    let avatarURL: URL?
    let reposURL: URL?
    let location: String?
    let email: String?
    let bio: String?
    let publicRepos: Int?
    let followers: Int?
    let following: Int?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case login = "login"
        case avatarURL = "avatar_url"
        case reposURL = "repos_url"
        case location, email, bio
        case publicRepos = "public_repos"
        case followers, following
        case createdAt = "created_at"
    }
}
