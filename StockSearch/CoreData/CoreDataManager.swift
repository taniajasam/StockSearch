//
//  CoreDataManager.swift
//  StockSearch
//
//  Created by Tania Jasam on 11/04/20.
//  Copyright © 2020 Tania Jasam. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {
        
    }
    
    func saveUsers(usersData: [UserResponse], completion: ()->()) {
        prepareDataForDB(usersData: usersData)
        saveContext()
        completion()
    }
    
    func fetchUsers() -> [User] {
        do {
            let users = try managedObjectContext.fetch(User.fetch())
            return users
        } catch {
            print("Exception occured while fetching data")
        }
        return [User]()
    }
    
    func fetchBlacklistedQueries() -> [BlacklistedQuery] {
        do {
            let queries = try managedObjectContext.fetch(BlacklistedQuery.fetch())
            return queries
        } catch {
            print("Exception occured while fetching data")
        }
        return [BlacklistedQuery]()
    }
    
    private func prepareDataForDB(usersData: [UserResponse]) {
        if usersData.count > 0 {
            for userResponse in usersData {
                _ = createUserEntity(userResponse: userResponse)
            }
            print("processed all users")
        }
    }
    
    func updateEntity(user: User, completion: ()->()) {
        let fetchRequest = User.fetch()
        fetchRequest.predicate = NSPredicate(format: "id = %d", user.id)
        do {
            let fetchedUser = try managedObjectContext.fetch(fetchRequest)
            fetchedUser[0].isFavorite = !fetchedUser[0].isFavorite
            saveContext()
            completion()
        } catch {
            print("Exception occured while fetching data")
        }
    }
    
    func deleteEntity(user: User, completion : ()->()) {
        let fetchRequest = User.fetch()
        fetchRequest.predicate = NSPredicate(format: "id = %d", user.id)
        do {
            let fetchedUser = try managedObjectContext.fetch(fetchRequest)
            managedObjectContext.delete(fetchedUser[0])
            saveContext()
            completion()
        } catch {
            print("Exception occured while fetching data")
        }
    }
    
    func addQueryToBlacklist(query: String) {
        let blacklistedQuery = BlacklistedQuery(context: self.managedObjectContext)
        blacklistedQuery.query = query
        saveContext()
    }
    
    @discardableResult
    private func createUserEntity(userResponse: UserResponse) -> User {
        let user = User(context: self.managedObjectContext)
        user.displayName = userResponse.displayName ?? ""
        user.avatarUrl = userResponse.avatarUrl ?? ""
        user.id = Int16(userResponse.id ?? 0)
        user.username = userResponse.username ?? ""
        user.isFavorite = false
        return user
    }
    
    
    // MARK: - Core Data stack
    
    private lazy var managedObjectContext = {
        
        return self.persistentContainer.viewContext
    }()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "StockSearch")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
