//
//  HomeViewController.swift
//  StockSearch
//
//  Created by Tania Jasam on 11/04/20.
//  Copyright © 2020 Tania Jasam. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchBar: UISearchBar!
    private let homeViewModel = HomeViewModel()
    private var navigator: IHomeViewNavigator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersTableView.rowHeight = UITableView.automaticDimension
        usersTableView.estimatedRowHeight = 100
        searchBar.backgroundImage = UIImage()
        self.headerLabel.frame = CGRect(x: 16, y: 80, width: 80, height: 40)
        self.headerLabel.font = UIFont(name: "MarkerFelt-Wide", size: 25)
        
        navigator = HomeViewNavigator(navigator: self.navigationController)
        
        homeViewModel.reload = {
            DispatchQueue.main.async { [weak self] in
                //                self?.setupViews()
                //                print(self?.homeViewModel.users?[46].displayName ?? "")
            }
        }
        registerTableViewCells()
        homeViewModel.fetchDataFromDB()
    }
    
    func registerTableViewCells() {
        usersTableView.register(UINib(nibName: AppConstants.ViewIdentifiers.userTableCellIdentifier, bundle: nil), forCellReuseIdentifier: AppConstants.ViewIdentifiers.userTableCellIdentifier)
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.ViewIdentifiers.userTableCellIdentifier, for: indexPath) as? UsersTableViewCell
        cell?.userDisplayNameLabel.text = homeViewModel.users?[indexPath.row].displayName ?? ""
        return cell!
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if usersTableView.contentOffset.y == 0 {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.headerViewHeightConstraint.constant = 120
                self.headerLabel.frame = CGRect(x: 16, y: 80, width: 80, height: 40)
                self.headerLabel.font = UIFont(name: "MarkerFelt-Wide", size: 25)
                self.view.layoutIfNeeded()

            }) { (isCompleted) in
            }
            
        } else if usersTableView.contentOffset.y > 0 {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.headerViewHeightConstraint.constant = 60
                self.headerLabel.frame = CGRect(x: self.headerView.frame.size.width/2 - 40, y: 16, width: 80, height: 40)
                self.headerLabel.font = UIFont(name: "MarkerFelt-Wide", size: 18)
                self.view.layoutIfNeeded()
            }) { (isCompleted) in
            }
            
        }
    }
    
}
