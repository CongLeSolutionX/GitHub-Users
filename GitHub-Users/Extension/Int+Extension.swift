//
//  Int+Extension.swift
//  GitHub-Users
//
//  Created by Cong Le on 4/28/20.
//  Copyright © 2020 CongLeSolutionX. All rights reserved.
//

import Foundation

extension Int {
    // epoch seconds into seconds
    var remaining: (minutes: Int, seconds: Int) {
        let expirationDate = Date(timeIntervalSince1970: TimeInterval(self))
        let timeRemaining = expirationDate.timeIntervalSince(Date())
        return (Int(timeRemaining / 60.0),
                Int(timeRemaining.truncatingRemainder(dividingBy: 60.0)))
    }
}
