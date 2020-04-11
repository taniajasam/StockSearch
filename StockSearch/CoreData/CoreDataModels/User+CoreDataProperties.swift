//
//  User+CoreDataProperties.swift
//  StockSearch
//
//  Created by Tania Jasam on 11/04/20.
//  Copyright © 2020 Tania Jasam. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetch() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var displayName: String?
    @NSManaged public var id: Int16
    @NSManaged public var avatarUrl: String?
    @NSManaged public var username: String?
    @NSManaged public var isFavorite: Bool

}
