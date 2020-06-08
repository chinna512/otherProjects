//
//  OTTDetails+CoreDataClass.swift
//  MahiCreations
//
//  Created by k.chinnababu on 07/06/20.
//  Copyright © 2020 Mahi Info services. All rights reserved.
//
//

import Foundation
import CoreData

@objc(OTTDetails)
public class OTTDetails: NSManagedObject {
    
    class func createObject(inContext:NSManagedObjectContext) -> OTTDetails{
          return OTTDetails.newObjectInContext(managedObjectContext: inContext) as! OTTDetails
      }

}
