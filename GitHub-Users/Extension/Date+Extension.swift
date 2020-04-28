//
//  Date+Extension.swift
//  GitHub-Users
//
//  Created by Cong Le on 4/28/20.
//  Copyright © 2020 CongLeSolutionX. All rights reserved.
//

import Foundation
// Converting Date to miliseconds and vice versa 
extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
