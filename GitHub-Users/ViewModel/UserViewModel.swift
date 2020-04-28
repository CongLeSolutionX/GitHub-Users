//
//  UserViewModel.swift
//  GitHub-Users
//
//  Created by Cong Le on 4/21/20.
//  Copyright © 2020 CongLeSolutionX. All rights reserved.
//

import Foundation

protocol NavigationProtocol {
    var navTitle: String { get }
}


class UserViewModel: NavigationProtocol {
    var navTitle: String {
        return "GitHub Searcher"
    }
    
    var userNetworkService: SearchUserService
    var userDetailNetworkService: SearchUserDetailService
    var rateLimitNetworkService: RateLimitService
    
    var updateClosure: (() -> Void)?
    var onError: (() -> Void)?
    
    private var users = [User]() {
        didSet {
            self.updateClosure?()
        }
    }
    
    private var rateLimit = RateLimit()
    
    private(set) var error: ErrorDescription? {
        didSet {
            if error != nil {
                self.onError?()
            }
        }
    }
    
    init(userService: SearchUserService = UserNetworkService(),
         userDetailService: SearchUserDetailService = UserDetailNetworkService(),
         rateLimitService: RateLimitService = RateLimitNetworkService()) {
        self.userNetworkService = userService
        self.userDetailNetworkService = userDetailService
        self.rateLimitNetworkService = rateLimitService
    }
    
    func getRateLimit(completionHandler: @escaping(RateLimitViewModel?) -> Void) {
        rateLimitNetworkService.getRateLimit {  (response) in
            switch response {
            case .success(let rate):
                let RateLimitVM = RateLimitViewModel(rateLimit: rate)
                completionHandler(RateLimitVM)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getUser(_ searchTerm: String) {
        userNetworkService.getUsers(with: searchTerm) { [weak self] (response) in
            switch response {
            case .success(let user):
                self?.users = user
            case .failure(let error):
                self?.error = error
            }
        }
    }
    
    func getUserDetailVM(for index: Int,
                         completionHandler: @escaping(UserDetailViewModel?) -> Void ) {
        userDetailNetworkService.getUserDetail(users[index].url) { response in
            switch response {
            case .success(let userDetail):
                let userDetailVM = UserDetailViewModel(userDetail)
                completionHandler(userDetailVM)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil)
            }
        }
    }
    
    func getCountOfUsers() -> Int {
        return users.count
    }
}
