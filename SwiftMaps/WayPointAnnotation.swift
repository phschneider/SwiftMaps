//
//  WayPointAnnotation.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 07.04.17.
//  Copyright © 2017 phschneider.net. All rights reserved.
//

import Foundation
import MapKit

class WayPointAnnotation: NSObject, MKAnnotation {
    var myCoordinate: CLLocationCoordinate2D
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.myCoordinate = coordinate
        self.title = title
    }
    
    init(myCoordinate: CLLocationCoordinate2D) {
        self.myCoordinate = myCoordinate
    }
    
    var coordinate: CLLocationCoordinate2D {
        return myCoordinate
    }
}

