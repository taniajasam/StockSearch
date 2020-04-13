//
//  WatchlistViewController.swift
//  StockSearch
//
//  Created by Tania Jasam on 12/04/20.
//  Copyright © 2020 Tania Jasam. All rights reserved.
//

import UIKit

class WatchlistViewController: UIViewController {
    
    @IBOutlet weak var watchlistHeaderView: UIView!
    @IBOutlet weak var watchlistHeaderLabel: UILabel!
    @IBOutlet weak var watchlistTableView: UITableView!
    @IBOutlet weak var watchlistHeaderViewHeightConstraint: NSLayoutConstraint!
    
    var watchlistViewModel = WatchlistViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        watchlistViewModel.reload = {
            DispatchQueue.main.async { [weak self] in
                self?.watchlistTableView.reloadData()
            }
        }
        setUpViews()
        registerTableViewCells()
        watchlistViewModel.fetchDataFromDB()
    }
    
    func setUpViews() {
        watchlistHeaderLabel.frame = CGRect(x: 16, y: 80, width: 250, height: 40)
        watchlistHeaderLabel.font = UIFont(name: "Rockwell", size: 32)
    }
    
    func registerTableViewCells() {
        watchlistTableView.rowHeight = UITableView.automaticDimension
        watchlistTableView.estimatedRowHeight = 100
        watchlistTableView.register(UINib(nibName: AppConstants.ViewIdentifiers.userTableCellIdentifier, bundle: nil), forCellReuseIdentifier: AppConstants.ViewIdentifiers.userTableCellIdentifier)
    }
    
    @IBAction func didClickOnBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension WatchlistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchlistViewModel.watchlistUsers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.ViewIdentifiers.userTableCellIdentifier, for: indexPath) as? UsersTableViewCell
        cell?.viewMode = .watchlist
        cell?.userDisplayNameLabel.text = watchlistViewModel.watchlistUsers?[indexPath.row].displayName ?? ""
        cell?.usernameLabel.text = watchlistViewModel.watchlistUsers?[indexPath.row].username ?? ""
        cell?.userImageView.kf.setImage(with: URL(string: watchlistViewModel.watchlistUsers?[indexPath.row].avatarUrl ?? ""))
        return cell!
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if watchlistTableView.contentOffset.y == 0 {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.watchlistHeaderViewHeightConstraint.constant = 120
                self.watchlistHeaderLabel.frame = CGRect(x: 0, y: 80, width: 250, height: 40)
                self.watchlistHeaderLabel.font = UIFont(name: "Rockwell", size: 32)
                self.view.layoutIfNeeded()
                
            }) { (isCompleted) in
            }
            
        } else if watchlistTableView.contentOffset.y > 0 {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.watchlistHeaderViewHeightConstraint.constant = 60
                self.watchlistHeaderLabel.frame = CGRect(x: self.watchlistHeaderView.frame.size.width/2 - 125, y: 16, width: 250, height: 40)
                self.watchlistHeaderLabel.font = UIFont(name: "Rockwell", size: 22)
                self.view.layoutIfNeeded()
            }) { (isCompleted) in
            }
            
        }
    }
}
