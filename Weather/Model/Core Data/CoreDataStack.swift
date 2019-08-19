//
//  CoreDataStack.swift
//  Weather
//
//  Created by Nabeera K Shirin on 5/01/19.
//  Copyright © 2019 dummy. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataStack {
    static let shared = CoreDataStack()
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Weather")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                let alert = UIAlertController(title: "", message: "Found error while loading data", preferredStyle: .alert)
                print(error)
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
                let nserror = error as NSError
                print(nserror)
                
            }
        }
    }
}
