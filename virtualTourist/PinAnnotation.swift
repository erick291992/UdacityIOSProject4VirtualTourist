//
//  PinAnnotation.swift
//  virtualTourist
//
//  Created by Erick Manrique on 6/2/16.
//  Copyright © 2016 appsathome. All rights reserved.
//

import Foundation
import MapKit

class PinAnnotation: NSObject,MKAnnotation {
    
    var pin:Pin?
    var coordinate: CLLocationCoordinate2D
    
    init(latitude: Double, longitude:Double) {
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}