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
        setupTableView()
        setupViewModel()
    }

    func setupSearchBar() {
        self.title = userViewModel.navTitle
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Users"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    func setupTableView() {
        userTableView.delegate = self
        userTableView.dataSource = self
        // self-sizing cells dymanically
        userTableView.rowHeight = UITableView.automaticDimension
        userTableView.estimatedRowHeight = 50.0
        
        // get the user cells
        userTableView.register(UserTableViewCell.self, forCellReuseIdentifier: CellID.userCellReuseIdentifier)
    }
    
    func setupViewModel() {
        userViewModel.updateClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.userTableView.reloadData()
            }
        }
        userViewModel.onError = { [weak self] in
            DispatchQueue.main.async {
                let errorMessage = self?.userViewModel.error?.errorDescription ?? "no error"
                print("Show some error here: \(errorMessage)")
            }
        }
    }
    
}

// MARK: UITableViewDelegate
extension UserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UserTableViewCell else {
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let repoViewController = storyboard.instantiateViewController(withIdentifier: "RepoViewController") as? RepoViewController else {
            fatalError("Scene not found in Storyboard")
        }
        let userVM = cell.userVM
        repoViewController.userVM = userVM
        present(repoViewController, animated: true, completion: nil)
    }
}


// MARK: UITableViewDataSource
extension UserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userViewModel.getCountOfUsers()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellID.userCellReuseIdentifier, for: indexPath)
            as? UserTableViewCell else {
                fatalError("Cannot dequeue cell")
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
        guard let searchTerm = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        search(searchTerm)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        search(searchTerm)
    }
    
    func search(_ searchTerm: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false,
                                     block: { [weak self] _ in
            self?.userViewModel.getUser(searchTerm)
        })
    }
}
