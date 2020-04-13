//
//  WatchlistViewModel.swift
//  StockSearch
//
//  Created by Tania Jasam on 13/04/20.
//  Copyright © 2020 Tania Jasam. All rights reserved.
//

import Foundation

class WatchlistViewModel {
    
    var watchlistUsers: [User]? {
        didSet {
            if let reloadBlock = self.reload {
                reloadBlock()
            }
        }
    }
    
    var reload: (() -> Void)? = nil

    func fetchDataFromDB() {
        let fetchedData = CoreDataManager.shared.fetchUsers()
        watchlistUsers = fetchedData.filter{$0.isFavorite}
    }
}
