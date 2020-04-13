//
//  UsersTableViewCell.swift
//  StockSearch
//
//  Created by Tania Jasam on 11/04/20.
//  Copyright © 2020 Tania Jasam. All rights reserved.
//

import UIKit

protocol UsersTableViewCellDelegate : class {
    func favoriteButtonClickedForCell(index:Int)
    func deleteButtonClickedForCell(index:Int)
}

class UsersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userDisplayNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var actionContainerView: UIView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var containerViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var viewMode: ViewMode? {
        didSet {
            if viewMode == .home {
                addSwipeGestureToContainerView()
            }
        }
    }
    weak var delegate: UsersTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpViews()
        addShadowView(customView: containerView)
        addShadowView(customView: actionContainerView)
    }
    
    func setUpViews() {
        userImageView.layer.cornerRadius = userImageView.frame.size.height/2
        favouriteButton.roundCorners(corners: [.topLeft,.bottomLeft], radius: 8)
        deleteButton.roundCorners(corners: [.topRight,.bottomRight], radius: 8)
    }
    
    func addShadowView(customView: UIView) {
        customView.layer.cornerRadius = 8.0
        customView.layer.shadowColor = UIColor.lightGray.cgColor
        customView.layer.shadowOpacity = 1
        customView.layer.shadowOffset = CGSize(width: 0, height: 3)
        customView.layer.shadowRadius = 4.0
    }
    
    func addSwipeGestureToContainerView() {
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(displayActionButtons))
        leftSwipeGesture.direction = .left
        containerView.addGestureRecognizer(leftSwipeGesture)
        
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(hideActionButtons))
        rightSwipeGesture.direction = .right
        containerView.addGestureRecognizer(rightSwipeGesture)
    }
    
    @objc func displayActionButtons()  {
        UIView.animate(withDuration: 0.75) { [weak self] in
            let frame = self?.containerView.frame
            self?.containerView.frame = CGRect(x: -164, y: frame?.origin.y ?? 0, width: frame?.size.width ?? 0, height: frame?.size.height ?? 0)
            let actionContainerFrame = self?.actionContainerView.frame
            self?.actionContainerView.frame = CGRect(x: (self?.containerView.frame.size.width ?? 0) - (actionContainerFrame?.size.width ?? 0), y: actionContainerFrame?.origin.y ?? 0, width: (actionContainerFrame?.size.width ?? 0 + 16), height: actionContainerFrame?.size.height ?? 0)
        }
    }
    
    @objc func hideActionButtons()  {
        UIView.animate(withDuration: 0.75) { [weak self] in
            let frame = self?.containerView.frame
            self?.containerView.frame = CGRect(x: 24, y: frame?.origin.y ?? 0, width: frame?.size.width ?? 0, height: frame?.size.height ?? 0)
            let actionContainerFrame = self?.actionContainerView.frame
            self?.actionContainerView.frame = CGRect(x: (self?.containerView.frame.size.width ?? 0) + (actionContainerFrame?.size.width ?? 0) + 16, y: actionContainerFrame?.origin.y ?? 0, width: (actionContainerFrame?.size.width ?? 0 - 16), height: actionContainerFrame?.size.height ?? 0)
        }
    }
    
    @IBAction func didClickOnFavoriteButton(_ sender: Any) {
        delegate?.favoriteButtonClickedForCell(index: self.tag)
    }
    
    
    @IBAction func didClickOnDeleteButton(_ sender: Any) {
        delegate?.deleteButtonClickedForCell(index: self.tag)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

enum ViewMode {
    case home
    case watchlist
}
