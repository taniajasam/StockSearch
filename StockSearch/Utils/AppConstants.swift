//
//  AppConstants.swift
//  StockSearch
//
//  Created by Tania Jasam on 11/04/20.
//  Copyright © 2020 Tania Jasam. All rights reserved.
//

import Foundation
import UIKit

struct AppConstants {
    struct API {
        static let users             = "https://api.jsonbin.io/b/5e8dcf95753e041b892bbefb"
    }
    
    struct ViewIdentifiers {
        static let userTableCellIdentifier  = "UsersTableViewCell"
        static let watchlistVCIdentifier    = "WatchlistViewController"
    }
    
    
    struct ViewFrames {
        struct Origin {
            static let headerLabelOrigin                = CGPoint(x: 16, y: 80)
            static let headerLabelTranslatedY:CGFloat   = 16
        }
        
        struct Height {
            static let headerViewHeight:CGFloat = 120
            static let headerLabel:CGFloat      = 40
        }
        struct Width {
            static let headerLabel:CGFloat      = 120

        }
    }
}
