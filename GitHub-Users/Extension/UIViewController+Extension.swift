//
//  UIViewController+Extension.swift
//  GitHub-Users
//
//  Created by Cong Le on 4/28/20.
//  Copyright © 2020 CongLeSolutionX. All rights reserved.
//

import UIKit

extension UIViewController {
    func showErrorAlert(text: String) {
        showAlert(text: text, subtext: "Please try again later.")
    }
    func showAlert(text: String, subtext: String? = nil) {
        let alert = UIAlertController(title: text, message: subtext, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}
