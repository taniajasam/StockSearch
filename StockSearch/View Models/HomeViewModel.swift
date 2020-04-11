//
//  HomeViewModel.swift
//  StockSearch
//
//  Created by Tania Jasam on 11/04/20.
//  Copyright © 2020 Tania Jasam. All rights reserved.
//

import Foundation

class HomeViewModel {
    
    var users: [User]? {
        didSet {
            if let reloadBlock = self.reload {
                reloadBlock()
            }
        }
    }
    
    var reload: (() -> Void)? = nil
    var error: (() -> Void)? = nil
    
    func fetchDataFromDB() {
        let fetchedData = CoreDataManager.shared.fetchUsers()
        if (fetchedData.count == 0) {
            fetchDataFromAPI()
        } else {
            self.users = fetchedData
        }
    }
    
    func fetchDataFromAPI() {
        weak var weakSelf = self
        NetworkManager.shared.fetchUsers(completion: { (homeResponse) in
            if let homeResponse = homeResponse {
                if homeResponse.users?.count ?? 0 > 0 {
                    weakSelf?.saveDataToDB(usersData: homeResponse.users ?? [])
                }
            } else {
                if let errorBlock = weakSelf?.error {
                    errorBlock()
                }
            }
        })
        
    }
    
    func saveDataToDB(usersData: [UserResponse]) {
        CoreDataManager.shared.saveUsers(usersData: usersData, completion: { [weak self] in
            self?.fetchDataFromDB()
        })
    }
}
