//
//  UserNetworkService.swift
//  GitHub-Users
//
//  Created by Cong Le on 4/21/20.
//  Copyright © 2020 CongLeSolutionX. All rights reserved.
//

import Foundation

typealias UserCompletionhandler = (_ result: Result<[User], ErrorDescription>) -> Void

protocol SearchUserService {
    func getUsers(with searchterm: String, completionHandler: @escaping UserCompletionhandler)
}

class UserNetworkService: SearchUserService {
    func getUsers(with query: String, completionHandler: @escaping UserCompletionhandler) {
        guard !query.isEmpty,
            let urlLink = GitHuAPI(query).userLink else {
            completionHandler(.failure(.init(errorDescription: "This is not a good URL link")))
            return
        }
        
        URLSession.shared.dataTask(with: urlLink) { (data, _, error) in
            if let errorReceived = error {
                completionHandler(.failure(.init(errorDescription: errorReceived.localizedDescription)))
                return
            }
            guard let dataReceived = data else {
                completionHandler(.failure(.init(errorDescription: "No data returned")))
                return
            }
            do {
                let result = try JSONDecoder().decode(Users.self, from: dataReceived)
                completionHandler(.success(result.users))
            } catch {
                completionHandler(.failure(.init(errorDescription: error.localizedDescription)))
                return
            }
        }.resume()
    }
}
