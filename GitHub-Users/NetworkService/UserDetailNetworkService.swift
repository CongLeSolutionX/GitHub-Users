//
//  UserInfoNetworkService.swift
//  GitHub-Users
//
//  Created by Cong Le on 4/22/20.
//  Copyright © 2020 CongLeSolutionX. All rights reserved.
//

import Foundation

typealias UserDetailHandler = (_ result: Result<UserInfo,ErrorDescription>) -> Void

protocol SearchUserDetailService: class {
    func getUserDetail(_ url: URL, completionHandler: @escaping UserDetailHandler)
}

class UserDetailNetworkService: SearchUserDetailService {
    func getUserDetail(_ url: URL, completionHandler: @escaping UserDetailHandler) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let errorReceived = error {
                completionHandler(.failure(.init(errorDescription: errorReceived.localizedDescription)))
                return
            }
            if let dataReceived = data {
                do {
                    let result = try JSONDecoder().decode(UserInfo.self, from: dataReceived)
                    completionHandler(.success(result))
                } catch {
                    print(error)
                    completionHandler(.failure(.init(errorDescription: error.localizedDescription)))
                    return
                }
            }
        }.resume() 
    }
    
    
}
