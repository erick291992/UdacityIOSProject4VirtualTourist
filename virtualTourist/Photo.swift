//
//  Photo.swift
//  virtualTourist
//
//  Created by Erick Manrique on 5/30/16.
//  Copyright © 2016 appsathome. All rights reserved.
//

import Foundation
import CoreData
class Photo: NSManagedObject{
    struct Keys {
        static let Tittle = "title"
        static let MediumURL = "url_m"
    }
    @NSManaged var title: String
    @NSManaged var mediumURL: String
}