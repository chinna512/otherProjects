//
//  OTTDetails+CoreDataProperties.swift
//  MahiCreations
//
//  Created by k.chinnababu on 07/06/20.
//  Copyright © 2020 Mahi Info services. All rights reserved.
//
//

import Foundation
import CoreData

extension OTTDetails {
    @NSManaged public var channelName: String?
    @NSManaged public var startDate: String?
    @NSManaged public var endDate: String?
    @NSManaged public var price: String?

}
