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
    // DIs
    var userNetworkService: SearchUserService
    var userDetailNetworkService: SearchUserDetailService
    
    var updateClosure: (() -> Void)?
    
    var users = [User]() {
        didSet {
            self.updateClosure?()
        }
    }
    // initilizer DI
    init(userService: SearchUserService = UserNetworkService(),
         userDetailService: SearchUserDetailService = UserDetailNetworkService()  ) {
        self.userNetworkService = userService
        self.userDetailNetworkService = userDetailService
    }
    
    
    func getUser(_ searchTerm: String) {
        userNetworkService.getUsers(with: searchTerm) { [weak self] (response) in
            switch response {
            case .success(let user):
                let userObject = user
                self?.users = userObject
                print(userObject)
            case .failure(let error ):
                print(error)
            }
        }
    }
    
    func getUserDetailVM(for index: Int, completionHandler: @escaping( UserDetailViewModel?) -> Void ) {
        userDetailNetworkService.getUserDetail(users[index].url ) { response in
            switch response {
            case .success(let userDetail):
                let userDetailVM = UserDetailViewModel(userDetail)
                completionHandler(userDetailVM)
                print(self.users[index].url)
                print("Getting user details.......\(userDetailVM.avatarURL)")
            case .failure(let error ):
                print(error)
                completionHandler(nil)
            }
            
        }
    }
    
    func getCountOfUsers() -> Int {
        return users.count
    }
    
}
