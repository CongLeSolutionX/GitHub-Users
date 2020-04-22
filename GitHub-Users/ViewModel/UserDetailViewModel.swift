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
    
    init(_ userInfor: UserInfo) {
        self.userDetail = userInfor
    }
    
    var username: String? {
           return userDetail.login
       }

       var avatarURL: URL? {
           return userDetail.avatarURL
       }
       
       var reposURL: URL? {
           return userDetail.reposURL
       }
       
       var repoCount: Int? {
           return userDetail.publicRepos
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
       
       var followers: Int? {
           return userDetail.followers
       }
       
       var following: Int? {
           return userDetail.following
       }
       
       var date: String? {
        guard let readableDate = dateFormatter.date(from: userDetail.createdAt ?? "N/A") else {return nil}
           dateFormatter.formatOptions = .withDashSeparatorInDate
           return dateFormatter.string(from: readableDate)
       }
}
