//
//  RepoTableViewCell.swift
//  GitHub-Users
//
//  Created by Cong Le on 4/22/20.
//  Copyright © 2020 CongLeSolutionX. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    
    var repoVM: RepoViewModel? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self,
                    let repoVM = self.repoVM else { return }
                self.repoNameLabel.text = repoVM.name
                self.forksLabel.text = repoVM.forks
                self.starsLabel.text = repoVM.stars
            }
            
        }
    }
}
