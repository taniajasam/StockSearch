//
//  UsersTableViewCell.swift
//  StockSearch
//
//  Created by Tania Jasam on 11/04/20.
//  Copyright © 2020 Tania Jasam. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {

    @IBOutlet weak var userDisplayNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var actionContainerView: UIView!
    
    @IBOutlet weak var actionContainerViewLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var actionContainerViewTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var containerViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var actionContainerViewWidthConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpViews()
        addShadowView()
        addSwipeGestureToContainerView()
    }

    func setUpViews() {
        userImageView.layer.cornerRadius = userImageView.frame.size.height/2
    }
    
    func addShadowView() {
        containerView.layer.cornerRadius = 8.0
        containerView.layer.shadowColor = UIColor.lightGray.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        containerView.layer.shadowRadius = 4.0
    }
    
    func addSwipeGestureToContainerView() {
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(displayActionButtons(swipeGesture:)))
        leftSwipeGesture.direction = .left
        containerView.addGestureRecognizer(leftSwipeGesture)
        
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(hideActionButtons(swipeGesture:)))
        rightSwipeGesture.direction = .right
        containerView.addGestureRecognizer(rightSwipeGesture)
    }
    
    @objc func displayActionButtons(swipeGesture: UISwipeGestureRecognizer)  {
        print(swipeGesture.direction)
        containerViewLeadingConstraint.constant = -180
        actionContainerViewLeadingConstraint.constant = 16
        actionContainerViewTrailingConstraint.constant = 16
        actionContainerViewWidthConstraint.constant = 150
    }
    
    @objc func hideActionButtons(swipeGesture: UISwipeGestureRecognizer)  {
           print(swipeGesture.direction)
           containerViewLeadingConstraint.constant = 24
           actionContainerViewLeadingConstraint.constant = 0
           actionContainerViewTrailingConstraint.constant = 0
           actionContainerViewWidthConstraint.constant = 0
       }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
