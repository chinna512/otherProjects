//
//  NSManagedObject.swift
//  Jiva App
//
//  Created by Administrator on 18/06/15.
//  Copyright (c) 2015 ZeOmega Inc. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject
{
    /** Creates and returns a new NSManagedObject.
    *  @param managedObjectContext The NSManagedObjectContext in which to create the managed object.
    *  @return The created NSManagedObject.
    */
    class func  newObjectInContext(managedObjectContext : NSManagedObjectContext) ->NSManagedObject
    {
       return NSEntityDescription.insertNewObject(forEntityName: String(describing: self), into:managedObjectContext)
    }
    
}
