//
//  UserTableViewCell.swift
//  GitHub-Users
//
//  Created by Cong Le on 4/22/20.
//  Copyright © 2020 CongLeSolutionX. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    lazy var userImage: UIImageView = {
        let albumImage = UIImageView()
        albumImage.contentMode = .scaleAspectFill
        return albumImage
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "User name"
        return label
    }()
    lazy var repoNumberLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        label.font = UIFont.italicSystemFont(ofSize: 15)
        label.text = "Repo Number"
        
        return label
    }()
    
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
                self.repoNumberLabel.text = userVM.repoCountString
            }
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String? ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addUIElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        contentView.backgroundColor = UIColor.clear
    }
    
    func addUIElements() {
        contentView.addSubview(userImage)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(repoNumberLabel)
        setUserImageConstraints()
        setUserNameLabelConstraints()
        setRepoNumberLabelConstraints()
    }
    
    func setUserImageConstraints() {
        userImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userImage.widthAnchor.constraint(equalTo: userImage.heightAnchor),
            userImage.widthAnchor.constraint(equalToConstant: 80),
            userImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            userImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: userImage.bottomAnchor, constant: 12)
        ])
    }
    
    func setUserNameLabelConstraints() {
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
       
        NSLayoutConstraint.activate([
            userNameLabel.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 20),
            userNameLabel.trailingAnchor.constraint(equalTo: repoNumberLabel.leadingAnchor, constant: 0),
            userNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            userNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func setRepoNumberLabelConstraints() {
        repoNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            repoNumberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            repoNumberLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 43)
        ])
    }
}
