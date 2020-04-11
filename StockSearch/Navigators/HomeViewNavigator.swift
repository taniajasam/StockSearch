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
    init(navigator: UINavigationController?)
    func showWatchlistView()
}

class HomeViewNavigator: IHomeViewNavigator {
    
    weak var navigator: UINavigationController?
    
    required init(navigator: UINavigationController?) {
        self.navigator = navigator
    }
    
    func showWatchlistView() {
//        if let categoryDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: AppConstants.ViewIdentifiers.categoryDetailVC) as? CategoryDetailViewController {
//            categoryDetailVC.categoryViewModel.category = category
//            self.navigator?.pushViewController(categoryDetailVC, animated: true)
//        }
    }
}
