//
//  RateLimitModel.swift
//  GitHub-Users
//
//  Created by Cong Le on 4/27/20.
//  Copyright © 2020 CongLeSolutionX. All rights reserved.
//

import Foundation
class RateLimitViewModel {
    
    private let rateLimit: RateLimit
    
    init(rateLimit: RateLimit) {
        self.rateLimit = rateLimit
    }
    
    var limitRequest: Int? {
        return rateLimit.rate?.limit
    }
    
    var remainingRequest: Int? {
        return rateLimit.rate?.remaining
    }
    var resetTime: Int? {
        return rateLimit.rate?.reset
    }
}
