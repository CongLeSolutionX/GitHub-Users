//
//  RateLimit.swift
//  GitHub-Users
//
//  Created by Cong Le on 4/27/20.
//  Copyright © 2020 CongLeSolutionX. All rights reserved.
//

import Foundation

// MARK: - RateLimit
struct RateLimit: Codable {
    var resources: Resources?
    var rate: Rate?
}

// MARK: - Rate
struct Rate: Codable {
    var limit, remaining, reset: Int?
}

// MARK: - Resources
struct Resources: Codable {
    var core, graphql, manifest, search: Rate?

    enum CodingKeys: String, CodingKey {
        case core, graphql
        case manifest = "integration_manifest"
        case search
    }
}
