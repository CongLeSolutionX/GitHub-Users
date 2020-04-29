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
    
    private var users = [UserInfo]() {
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
    
    func getUserDetailVM(for index: Int) -> UserDetailViewModel {
        UserDetailViewModel(users[index])
    }
        
    func getCountOfUsers() -> Int {
        return users.count
    }
}

extension UserViewModel {
    
   
    
    func getUser(_ searchTerm: String) {
        let getUsersCompletion: UserCompletionhandler = { [weak self] (response) in
            guard let self = self else { return }
            switch response {
                case .success(let users):
                    self.fetchUsers(users)
                case .failure(let error):
                    self.error = error
            }
        }
        userNetworkService.getUsers(with: searchTerm, completionHandler: getUsersCompletion)
    }
    
    private func fetchUsers(_ users: [User]) {
        var userInfos = [UserInfo]()
        var errors = [ErrorDescription]()
        let lock = NSLock()
        let group = DispatchGroup()
        for user in users {
            group.enter()
            self.userDetailNetworkService.getUserDetail(user.url) { response in
                defer { group.leave() }
                lock.lock(); defer { lock.unlock() }
                switch response {
                    case .success(let userDetail):
                        userInfos.append(userDetail)
                    case .failure(let error):
                        errors.append(error)
                }
            }
        }
        group.notify(queue: .main) {
            if userInfos.isEmpty {
                self.determineError(with: errors)
            } else {
                self.error = nil
                self.users = userInfos
            }
        }
    }
    
    func getRateLimit(completionHandler: @escaping(RateLimitViewModel?) -> Void) {
        rateLimitNetworkService.getRateLimit { (response) in
            switch response {
                case .success(let rate):
                    let RateLimitVM = RateLimitViewModel(rateLimit: rate)
                    completionHandler(RateLimitVM)
                case .failure:
                    completionHandler(nil)
            }
        }
    }
    
    func determineError(with errors: [ErrorDescription]) {
        self.getRateLimit { response in
            let error: ErrorDescription
            if let response = response, let remainingRequest = response.remainingRequest, remainingRequest == 0 {
                let timeRemaining = response.resetTime?.remaining
                let errorString = """
                Requests available: \(remainingRequest)\\\(response.limitRequest ?? 0)
                Reset time is in: \(timeRemaining?.minutes ?? 0) minutes and \(timeRemaining?.seconds ?? 0) seconds
                If this remaining request hit 0, just wait to the next hour to make new request.
                """
                error = ErrorDescription(errorDescription: errorString)
            }
            else {
                error = errors.first ?? ErrorDescription.rateLimitExceeded
            }
            self.error = error
            self.users = []
        }
    }
}
