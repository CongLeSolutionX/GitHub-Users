//
//  RepoViewModel.swift
//  GitHub-Users
//
//  Created by Cong Le on 4/22/20.
//  Copyright © 2020 CongLeSolutionX. All rights reserved.
//

import Foundation

class RepoViewModel {
    
    private let repo: Repo
    
    init(repo: Repo) {
        self.repo = repo
    }

    var name: String {
        return repo.name
    }
    
    var forks: String {
        return String(repo.forks) + " Forks"
    }
    
    var stars: String {
        return String(repo.stars) + " Stars"
    }
}
