//
//  URL+DownloadImage.swift
//  GitHub-Users
//
//  Created by Cong Le on 4/22/20.
//  Copyright © 2020 CongLeSolutionX. All rights reserved.
//

import UIKit

typealias ImageHandler = (UIImage?) -> Void

extension URL {
    func downloadImage(completionHandler: @escaping ImageHandler ) {
        URLSession.shared.dataTask(with: self) { (data, _, _ ) in
            if let dataReceived = data {
                let img = UIImage(data: dataReceived)
                DispatchQueue.main.async {
                    completionHandler(img)
                }
            }
        }.resume() 
    }
}
