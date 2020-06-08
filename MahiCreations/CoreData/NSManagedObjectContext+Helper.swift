//
//  NSManagedObjectContext+Helper.swift
//  Jiva App
//
//  Created by Basavaraj on 18/11/15.
//  Copyright © 2015 ZeOmega Inc. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext{
    
    /** Creates and returns a NSManagedObjectContext object with the singleton NSPersistentStoreCoordinator and the storage file for this app.
    *  @return The NSManagedObjectContext object.
    */
    class func newContext()->NSManagedObjectContext{
        return AppCoredata.sharedInstance.managedObjectContext
    }
    
    class func newChildContext()->NSManagedObjectContext{
        return AppCoredata.sharedInstance.childManagedObjectContext
    }
    
    /** The global NSManagedObjectModel for this app */
    var managedObjectModel:NSManagedObjectModel{
        return AppCoredata.sharedInstance.managedObjectModel
    }
    
    @discardableResult func HMSave()->Bool{
        var result = true
        let managedObjectContext = AppCoredata.sharedInstance.managedObjectContext
        let writerObjectContext = AppCoredata.sharedInstance.writerManagedObjectContext
        
        if hasChanges {
            do {
                try save()
            } catch {
                let nserror = error as NSError
                result = false
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        managedObjectContext.perform { () -> Void in
            if managedObjectContext.hasChanges {
                do {
                    try managedObjectContext.save()
                } catch {
                    let nserror = error as NSError
                    result = false
                    NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
            if writerObjectContext.hasChanges {
                writerObjectContext.perform({ () -> Void in
                    // Save the context.
                    do {
                        try writerObjectContext.save()
                    } catch {
                        let nserror = error as NSError
                        result = false
                        NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                    }
                })
            }
        }
        return result
    }

    /**
     *  This method Destroys presistent store and adds new presistent store.
     */
    func deleteAllData()
    {
        let managedObjectContext = AppCoredata.sharedInstance.managedObjectContext
        guard let persistentStore = managedObjectContext.persistentStoreCoordinator?.persistentStores.last else {
            return
        }

        let url = managedObjectContext.persistentStoreCoordinator?.url(for: persistentStore)
        self.reset()
        managedObjectContext.reset()
        do
        {
            let mOptions = [NSMigratePersistentStoresAutomaticallyOption: false,
                            NSInferMappingModelAutomaticallyOption: true]
            try managedObjectContext.persistentStoreCoordinator?.destroyPersistentStore(at: url!, ofType: NSSQLiteStoreType, options: mOptions)
            try managedObjectContext.persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: mOptions)
        }
        catch {
            print(error)
        }
    }
}
