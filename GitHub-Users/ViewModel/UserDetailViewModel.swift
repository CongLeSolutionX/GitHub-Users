//
//  UserDetailViewModel.swift
//  GitHub-Users
//
//  Created by Cong Le on 4/22/20.
//  Copyright © 2020 CongLeSolutionX. All rights reserved.
//

import Foundation

class UserDetailViewModel {
    lazy var dateFormatter: ISO8601DateFormatter = ISO8601DateFormatter()
    private let userDetail: UserInfo
    let imageService = ImageService()
    let repoService: RepoService
    
    var updateClosure: (() -> Void)?
    var onError: (() -> Void)?
    private var _repos: [Repo] = [] {
        didSet {
            repos = _repos
        }
    }
    
    private var repos: [Repo] = [] {
        didSet {
            self.updateClosure?()
        }
    }
    private(set) var error: ErrorDescription? {
        didSet {
            if error != nil {
                self.onError?()
            }
        }
    }
    
    init(_ userInfo: UserInfo,
         _ repoService: RepoService = RepoNetworkService()) {
        self.userDetail = userInfo
        self.repoService = repoService
    }
}

// MARK: - UserInfo

extension UserDetailViewModel {
    
    var username: String? {
        return userDetail.login
    }
    
    var avatarURL: URL? {
        return userDetail.avatarURL
    }
    
    var reposURL: URL {
        return userDetail.reposURL
    }
        
    var repoCountString: String {
        return "Repos: " + String(userDetail.publicRepos)
    }
    
    var email: String? {
        return userDetail.email
    }
    
    var bio: String? {
        return userDetail.bio
    }
    
    var location: String? {
        return userDetail.location
    }
    
    var followers: String {
        return String(userDetail.followers) + " Followers"
    }
    
    var following: String {
        return "Following " + String(userDetail.following)
    }
    
    var date: String? {
        guard let readableDate = dateFormatter.date(from: userDetail.createdAt) else { return userDetail.createdAt }
        dateFormatter.formatOptions = .withDashSeparatorInDate
        return dateFormatter.string(from: readableDate)
    }
    
    func image(_ completion: @escaping (Data?)->Void) {
        guard let url = avatarURL else { completion(nil); return }
        imageService.download(url: url, completion)
    }
    
}

// MARK: - Repo

extension UserDetailViewModel {
    
    func getRepos() {
        repoService.getRepos(reposURL) { [weak self] (response) in
            guard let self = self else { return }
            switch response {
                case .success(let repos):
                    self._repos = repos
                case .failure(let error):
                    self.error = error
            }
        }
    }
    
    func search(_ searchTerm: String) {
        if searchTerm.isEmpty {
            repos = _repos
            return
        }
        let query = searchTerm.lowercased()
        repos = _repos.filter {
            $0.name.lowercased().contains(query)
        }
    }
    
    var repoCount: Int {
        return repos.count
    }
    
    func makeRepoViewModel(index: Int) -> RepoViewModel {
        let repo = repos[index]
        return RepoViewModel(repo: repo)
    }
    
    func repoUrl(index: Int) -> URL {
        let repo = repos[index]
        guard let url = URL(string: repo.url) else { fatalError() }
        return url
    }
}
