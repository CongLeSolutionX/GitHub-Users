//
//  RepoNetworkService.swift
//  GitHub-Users
//
//  Created by Cong Le on 4/22/20.
//  Copyright © 2020 CongLeSolutionX. All rights reserved.
//

import Foundation

typealias RepoHandler = (_ result: Result<[Repo],ErrorDescription>) -> Void

protocol RepoService: class {
    func getRepos(_ url: URL, completionHandler: @escaping RepoHandler)
}

class RepoNetworkService: RepoService {
    func getRepos(_ url: URL, completionHandler: @escaping RepoHandler) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let errorReceived = error {
                completionHandler(.failure(.init(errorDescription: errorReceived.localizedDescription)))
                return
            }
            guard let dataReceived = data else {
                completionHandler(.failure(.init(errorDescription: "No data returned")))
                return
            }
            do {
                let result = try JSONDecoder().decode([Repo].self, from: dataReceived)
                completionHandler(.success(result))
            } catch {
                completionHandler(.failure(.init(errorDescription: error.localizedDescription)))
                return
            }
            
        }.resume()
    }
    
}

