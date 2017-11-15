//
//  Weather+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Michil Khodulov on 13.11.2017.
//  Copyright © 2017 Michil Khodulov. All rights reserved.
//
//

import Foundation
import CoreData


extension Weather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weather> {
        return NSFetchRequest<Weather>(entityName: "Weather")
    }

    @NSManaged public var lastUpdated: NSDate?
    @NSManaged public var tempC: Double
    @NSManaged public var windKph: Double

}
