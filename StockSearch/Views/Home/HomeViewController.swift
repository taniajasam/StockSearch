//
//  HomeViewController.swift
//  StockSearch
//
//  Created by Tania Jasam on 11/04/20.
//  Copyright © 2020 Tania Jasam. All rights reserved.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var noDataErrorLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let homeViewModel = HomeViewModel()
    private var navigator: IHomeViewNavigator?
    
//MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigator = HomeViewNavigator(navigator: self)
        setUpViews()
        homeViewModel.reload = {
            DispatchQueue.main.async { [weak self] in
                self?.usersTableView.reloadData()
            }
        }
        registerTableViewCells()
        homeViewModel.fetchDataFromDB()
    }
    
//MARK: - Helper Methods
    
    func setUpViews() {
       searchBar.backgroundImage = UIImage()
        self.headerLabel.frame = CGRect(x: AppConstants.ViewFrames.Origin.headerLabelOrigin.x, y: AppConstants.ViewFrames.Origin.headerLabelOrigin.y, width: AppConstants.ViewFrames.Width.headerLabel, height: AppConstants.ViewFrames.Height.headerLabel)
        self.headerLabel.font = UIFont(name: "Rockwell", size: 32)
    }
    
    func registerTableViewCells() {
        usersTableView.rowHeight = UITableView.automaticDimension
        usersTableView.estimatedRowHeight = 100
        usersTableView.register(UINib(nibName: AppConstants.ViewIdentifiers.userTableCellIdentifier, bundle: nil), forCellReuseIdentifier: AppConstants.ViewIdentifiers.userTableCellIdentifier)
    }
    
    func setupViewForNoData(shouldShowError: Bool) {
        usersTableView.isHidden = shouldShowError
        noDataErrorLabel.isHidden = !shouldShowError
    }
    
//MARK: - Action Methods
    
    @IBAction func didClickOnWatchlistButton(_ sender: Any) {
        navigator?.showWatchlistView()
    }
    
    
}

//MARK: - Delegate Methods

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        setupViewForNoData(shouldShowError: homeViewModel.filteredUsers?.count ?? 0 > 0 ? false : true)
        return homeViewModel.filteredUsers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.ViewIdentifiers.userTableCellIdentifier, for: indexPath) as? UsersTableViewCell
        cell?.viewMode = .home
        cell?.tag = indexPath.row
        cell?.delegate = self
        cell?.favoriteButton.isSelected = homeViewModel.filteredUsers?[indexPath.row].isFavorite ?? false
        cell?.userDisplayNameLabel.text = homeViewModel.filteredUsers?[indexPath.row].displayName ?? ""
        cell?.usernameLabel.text = homeViewModel.filteredUsers?[indexPath.row].username ?? ""
        cell?.userImageView.kf.setImage(with: URL(string: homeViewModel.filteredUsers?[indexPath.row].avatarUrl ?? ""))
        return cell!
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if usersTableView.contentOffset.y == 0 {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.headerViewHeightConstraint.constant = AppConstants.ViewFrames.Height.headerViewHeight
                self.headerLabel.frame = CGRect(x: AppConstants.ViewFrames.Origin.headerLabelOrigin.x, y: AppConstants.ViewFrames.Origin.headerLabelOrigin.y, width: AppConstants.ViewFrames.Width.headerLabel, height: AppConstants.ViewFrames.Height.headerLabel)
                self.headerLabel.font = UIFont(name: "Rockwell", size: 32)
                self.view.layoutIfNeeded()
                
            }) { (isCompleted) in
            }
            
        } else if usersTableView.contentOffset.y > 0 {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.headerViewHeightConstraint.constant = AppConstants.ViewFrames.Height.headerViewHeight/2
                self.headerLabel.frame = CGRect(x: self.headerView.frame.size.width/2 - AppConstants.ViewFrames.Width.headerLabel/2, y: AppConstants.ViewFrames.Origin.headerLabelTranslatedY, width: AppConstants.ViewFrames.Width.headerLabel, height: AppConstants.ViewFrames.Height.headerLabel)
                self.headerLabel.font = UIFont(name: "Rockwell", size: 22)
                self.view.layoutIfNeeded()
            }) { (isCompleted) in
            }
            
        }
    }
    
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        homeViewModel.searchUser(queryString: searchText)
    }
}

extension HomeViewController: UsersTableViewCellDelegate {
    
    func favoriteButtonClickedForCell(index: Int) {
        homeViewModel.updateFavoriteStatus(index: index)
    }
    
    func deleteButtonClickedForCell(index: Int) {
        let cell = usersTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? UsersTableViewCell
        cell?.hideActionButtons()
        homeViewModel.deleteUser(index: index)
    }
}
