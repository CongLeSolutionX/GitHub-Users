//
//  UserInfoTableViewCell.swift
//  GitHub-Users
//
//  Created by Cong Le on 4/22/20.
//  Copyright © 2020 CongLeSolutionX. All rights reserved.
//

import UIKit

class UserInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var joinDateLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var biographyLabel: UILabel!
    @IBOutlet weak var repoSearchBar: UISearchBar!
    
    var userVM: UserDetailViewModel? {
        didSet {
            DispatchQueue.main.async {
                guard let userVM = self.userVM else { return }
                userVM.image { [weak self] (image) in
                    DispatchQueue.main.async {
                        guard let image = image else {
                            self?.userImage.image = nil
                            return
                        }
                        self?.userImage.image = UIImage(data: image)
                    }
                }
                self.userNameLabel.text = userVM.username
                self.emailLabel.text = userVM.email
                self.locationLabel.text = userVM.location
                self.joinDateLabel.text = userVM.date
                self.followersLabel.text = userVM.followers
                self.followingLabel.text = userVM.following
                self.biographyLabel.text = userVM.bio
            }
        }
    }

}
