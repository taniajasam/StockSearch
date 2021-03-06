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
            filteredUsers = users
        }
    }
    
    var filteredUsers: [User]? {
        didSet {
            if let reloadBlock = self.reload {
                reloadBlock()
            }
        }
    }
    
    var reload: (() -> Void)? = nil
    
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
            }
        })
        
    }
    
    func saveDataToDB(usersData: [UserResponse]) {
        CoreDataManager.shared.saveUsers(usersData: usersData, completion: { [weak self] in
            self?.fetchDataFromDB()
        })
    }
    
    func searchUser(queryString: String) {
        
        filteredUsers = users
        if queryString == "" {
            return
        }
        
        if queryString.count < 3 {
            return
        }
        
        if checkQueryInBlacklist(query: queryString) {
            filteredUsers = []
            return
        }
        
        var searchedUser = [User]()
        var rankings = [User: Int]()
        for user in users ?? [] {
            if !queryString.contains(" ") {
                var words = [String]()
                if user.displayName?.contains(" ") ?? false {
                    words = (user.displayName?.components(separatedBy: " "))!
                } else {
                    words.append(user.displayName ?? "")
                }
                words = words.map{$0.lowercased()}
                for (index,word) in words.enumerated() {
                    if let range = word.range(of: queryString.lowercased()) {
                        let startPos = word.distance(from: word.startIndex, to: range.lowerBound)
                        if startPos == 0 {
                            rankings[user] = index+1
                            break
                        }
                    }
                }
            } else {
                if user.displayName?.lowercased().contains(queryString) ?? false {
                    rankings[user] = 1
                }
            }
            
            for (key,_) in rankings.sorted(by: {$0.1 < $1.1}) {
                if !searchedUser.contains(key) {
                    searchedUser.append(key)
                }
            }
        }
        filteredUsers = searchedUser
        if searchedUser.count == 0 {
            CoreDataManager.shared.addQueryToBlacklist(query: queryString)
        }
    }
    
    func checkQueryInBlacklist(query: String) -> Bool {
        let blacklist = CoreDataManager.shared.fetchBlacklistedQueries()
        let queryList = blacklist.filter{$0.query == query}
        return queryList.count > 0 ? true : false
    }
    
    func updateFavoriteStatus(index: Int) {
        weak var weakself = self
        if let user = users?[index] {
            CoreDataManager.shared.updateEntity(user: user) {
                weakself?.fetchDataFromDB()
            }
        }
        
    }
    
    func deleteUser(index: Int) {
        weak var weakself = self
        if let user = users?[index] {
            CoreDataManager.shared.deleteEntity(user: user) {
                weakself?.fetchDataFromDB()
            }
        }
    }
}
