//
//  Extensions.swift
//  StockSearch
//
//  Created by Tania Jasam on 13/04/20.
//  Copyright © 2020 Tania Jasam. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
