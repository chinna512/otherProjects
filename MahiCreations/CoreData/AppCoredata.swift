//
//  AppCoredata.swift
//  Jiva App
//
//  Created by Basavaraj on 18/11/15.
//  Copyright © 2015 ZeOmega Inc. All rights reserved.
//

import Foundation
import CoreData

struct AppCoredataConstants {
    static let kSQLiteFileName       = ".ZeOmegaJivaApp.sqlite"
}

class AppCoredata{
 
    struct Static
    {
        static var sAppCoredata : AppCoredata? = nil
    }

    ///Create and returns the shared instance of AppCoredata
    static let sharedInstance:AppCoredata = {
        let instance = AppCoredata()
        return instance
    } ()
    
    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.zeomega.TestCoredata" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "MahiCreations", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent(AppCoredataConstants.kSQLiteFileName)
        let sqliteFileAbsoluteURLString = url!.path
        var failureReason = "There was an error creating or loading the application's saved data."
        let mOptions = [NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true]
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: mOptions)
            //ZJMUtility.addSkipBackupAttribute()
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        // Encrypt the database
        var fileProtectionError: NSError?
        var fileAttributesForEncryption = [FileAttributeKey.protectionKey: FileProtectionType.complete]
        do {
            try FileManager.default.setAttributes(fileAttributesForEncryption, ofItemAtPath: sqliteFileAbsoluteURLString)
        }
        catch let error as NSError {
            fileProtectionError = error
        }
        if let error = fileProtectionError {
            print("SQLite file is not encrypted: \(error), \(error.userInfo)")
        }
        
        return coordinator
    }()
    
    // Returns the managed object context for the application.
    // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
    lazy var managedObjectContext: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.parent = self.writerManagedObjectContext
        return managedObjectContext
    }()
    
    // Parent context
    lazy var writerManagedObjectContext:NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // Child Context
    lazy var childManagedObjectContext:NSManagedObjectContext = {
        let managedObjectContext = self.managedObjectContext
        var instance = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        instance.parent = managedObjectContext
        return instance
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext ()->Bool {
        var result = true
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                let nserror = error as NSError
                result = false
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        return result
    }
}
