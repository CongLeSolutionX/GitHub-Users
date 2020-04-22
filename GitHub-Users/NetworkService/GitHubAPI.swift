//
//  GitHubAPI.swift
//  GitHub-Users
//
//  Created by Cong Le on 4/21/20.
//  Copyright © 2020 CongLeSolutionX. All rights reserved.
//

import Foundation

class GitHuAPI {
    var userQuerry: String
    let base = "https://api.github.com/search/users?q="
    init(_ searchTerm: String) {
        self.userQuerry = searchTerm
    }
    
    var userLink: URL? {
        return URL(string: base + userQuerry)
    }
    
}
