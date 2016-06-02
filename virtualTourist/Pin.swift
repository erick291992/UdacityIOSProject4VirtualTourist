//
//  Pin.swift
//  virtualTourist
//
//  Created by Erick Manrique on 5/30/16.
//  Copyright © 2016 appsathome. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class Pin: NSManagedObject, MKAnnotation{
    
    @NSManaged var latitude:NSNumber
    @NSManaged var longitude:NSNumber
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(latitude:Double, longitude:Double, context: NSManagedObjectContext) {
        let entity =  NSEntityDescription.entityForName("Pin", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.latitude = NSNumber(double: latitude)
        self.longitude = NSNumber(double: longitude)
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude as Double, longitude: longitude as Double)
    }
    
//    init(coordinate: CLLocationCoordinate2D) {
//        self.latitude = coordinate.latitude
//        self.longitude = coordinate.longitude
//        self.coordinate = coordinate
//    }
}