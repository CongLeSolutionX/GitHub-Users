//
//  Repo.swift
//  GitHub-Users
//
//  Created by Cong Le on 4/22/20.
//  Copyright © 2020 CongLeSolutionX. All rights reserved.
//

import Foundation

struct Repo: Decodable {
    let name: String
    let forks: Int
    let stars: Int
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case forks = "forks_count"
        case stars = "stargazers_count"
        case url = "html_url"
    }
    
}
