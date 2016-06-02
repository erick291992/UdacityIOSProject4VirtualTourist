//
//  GCDBlackBox.swift
//  On The Map
//
//  Created by Erick Manrique on 4/18/16.
//  Copyright © 2016 appsathome. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}