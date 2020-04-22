//
//  ViewController.swift
//  GitHub-Users
//
//  Created by Cong Le on 4/21/20.
//  Copyright © 2020 CongLeSolutionX. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var userTableView: UITableView!
    private let searchController = UISearchController(searchResultsController: nil)
    var timer: Timer? = nil
    
    var userViewModel = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        displayUsers()
        
        
        
    }
    func setupSearchBar() {
        self.title = userViewModel.navTitle
        userViewModel.updateClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.userTableView.reloadData()
            }
        }
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Users"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    func displayUsers() {
        
        userTableView.delegate = self
        userTableView.dataSource = self
        // self-sizing cells dymanically
        userTableView.rowHeight = UITableView.automaticDimension
        userTableView.estimatedRowHeight = 50.0
        
        // get the user cells
        userTableView.register(UserTableViewCell.self, forCellReuseIdentifier: CellID.userCellReuseIdendtifier)
        
        
    }
    
}

// MARK: UITableViewDelegate
extension UserViewController: UITableViewDelegate {
    
    
}


// MARK: UITableViewDataSource
extension UserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userViewModel.getCountOfUsers()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellID.userCellReuseIdendtifier, for: indexPath)
            as? UserTableViewCell else {
                fatalError("cannot dequeue cell")
        }
        
        userViewModel.getUserDetailVM(for: indexPath.row) { response in
            cell.userVM = response
        }
        return cell
    }
}


// MARK: UISearchBarDelegate
extension UserViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: {
            [weak self] _ in
            guard let searchTerm = searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
            
            self?.userViewModel.getUser(searchTerm)
            
        })
        
        //                guard let searchTerm = searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        //                userViewModel.getUser(searchTerm)
    }
}
