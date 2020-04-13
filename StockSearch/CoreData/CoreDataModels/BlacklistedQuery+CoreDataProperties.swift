//
//  BlacklistedQuery+CoreDataProperties.swift
//  
//
//  Created by Tania Jasam on 13/04/20.
//
//

import Foundation
import CoreData


extension BlacklistedQuery {

    @nonobjc public class func fetch() -> NSFetchRequest<BlacklistedQuery> {
        return NSFetchRequest<BlacklistedQuery>(entityName: "BlacklistedQuery")
    }

    @NSManaged public var query: String?

}
