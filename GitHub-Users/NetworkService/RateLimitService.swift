//
//  RateLimitService.swift
//  GitHub-Users
//
//  Created by Cong Le on 4/27/20.
//  Copyright © 2020 CongLeSolutionX. All rights reserved.
//

import Foundation

protocol RateLimitService {
    func getRateLimit(completion: @escaping (_ result: Result<RateLimit, ErrorDescription>) -> Void)
}

class RateLimitNetworkService: RateLimitService {
    func getRateLimit(completion: @escaping (_ result: Result<RateLimit, ErrorDescription>) -> Void) {
       
         let rateLimitString = "https://api.github.com/rate_limit"
        guard let rateLink = URL(string: rateLimitString) else {
            return
        }
        URLSession.shared.dataTask(with: rateLink) { (data, _, _) in
            guard let rateLimit = data else {
                completion(.failure(.init(errorDescription: "Rate Limit Data")))
                return
            }
            do {
                let result = try JSONDecoder().decode(RateLimit.self, from: rateLimit)
                completion(.success(result))
                
            } catch {
                completion(.failure(.init(errorDescription: error.localizedDescription)))
                return
            }
        }.resume()
    }
    
}
