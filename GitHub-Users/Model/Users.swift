//
//  Users.swift
//  GitHub-Users
//
//  Created by Cong Le on 4/21/20.
//  Copyright © 2020 CongLeSolutionX. All rights reserved.
//

import Foundation

struct Users: Codable {
    let users: [User]
    enum CodingKeys: String, CodingKey {
        case users = "items"
    }
}
