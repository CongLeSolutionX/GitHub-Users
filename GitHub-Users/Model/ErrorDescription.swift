//
//  ErrorDescription.swift
//  GitHub-Users
//
//  Created by Cong Le on 4/21/20.
//  Copyright © 2020 CongLeSolutionX. All rights reserved.
//

import Foundation

struct ErrorDescription: Error {
    var errorDescription: String?
}

extension ErrorDescription {
    static let rateLimitExceededString = "Rate Limit Exceeded"
    static let rateLimitExceeded: ErrorDescription = .init(errorDescription: rateLimitExceededString)
}

extension ErrorDescription: CustomDebugStringConvertible {
    var debugDescription: String {
        return errorDescription ?? "Unknown error"
    }
}
