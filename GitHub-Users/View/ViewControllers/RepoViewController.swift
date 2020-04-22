//
//  RepoViewController.swift
//  GitHub-Users
//
//  Created by Cong Le on 4/21/20.
//  Copyright © 2020 CongLeSolutionX. All rights reserved.
//

import UIKit

class RepoViewController: UIViewController {
    
    @IBOutlet weak var repoInfoTableView: UITableView!
    
    var userVM: UserDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "GitHub Searcher"
        setupTableView()
        setupViewModel()
        userVM.getRepos()
    }
    
    func setupTableView() {
        repoInfoTableView.delegate = self
        repoInfoTableView.dataSource = self
        // self-sizing cells dynamically
        repoInfoTableView.rowHeight = UITableView.automaticDimension
        repoInfoTableView.estimatedRowHeight = 50.0
    }
    
    func setupViewModel() {
        userVM.updateClosure = {
            DispatchQueue.main.async {
                self.repoInfoTableView.reloadSections(.init(integer: 1), with: .automatic)
            }
        }
        userVM.onError = {
            DispatchQueue.main.async {
                let errorMessage = self.userVM.error?.errorDescription ?? "no error"
                print("Show some error here: \(errorMessage)")
            }
        }
    }

}

extension RepoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        let url = userVM.repoUrl(index: indexPath.row)
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

extension RepoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return userVM.repoCount
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellID.userCellReuseIdentifier, for: indexPath) as? UserInfoTableViewCell else {
                    fatalError("cannot dequeue cell")
                }
                cell.userVM = userVM
                cell.repoSearchBar.delegate = self
                return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellID.repoCellReuseIdentifier, for: indexPath) as? RepoTableViewCell else {
                fatalError("cannot dequeue cell")
            }
            cell.repoVM = userVM.makeRepoViewModel(index: indexPath.row)
            return cell
        }
    }
}

extension RepoViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        userVM.search(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        userVM.search(searchBar.text ?? "")
    }
}
