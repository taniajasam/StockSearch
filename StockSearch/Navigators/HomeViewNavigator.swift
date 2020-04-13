//
//  HomeViewNavigator.swift
//  StockSearch
//
//  Created by Tania Jasam on 11/04/20.
//  Copyright © 2020 Tania Jasam. All rights reserved.
//

import Foundation
import UIKit

protocol IHomeViewNavigator {
    init(navigator: UIViewController?)
    func showWatchlistView()
}

class HomeViewNavigator: IHomeViewNavigator {
    
    weak var navigator: UIViewController?
    
    required init(navigator: UIViewController?) {
        self.navigator = navigator
    }
    
    func showWatchlistView() {
        if let watchlistVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: AppConstants.ViewIdentifiers.watchlistVCIdentifier) as? WatchlistViewController {
            watchlistVC.modalPresentationStyle = .fullScreen
            watchlistVC.modalTransitionStyle = .flipHorizontal
            self.navigator?.present(watchlistVC, animated: true, completion: nil)
        }
    }
}
