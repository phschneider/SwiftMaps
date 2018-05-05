//
//  HighLowAnnotation.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 06.04.18.
//  Copyright © 2018 phschneider.net. All rights reserved.
//

import Foundation
import MapKit

class HighLowAnnotation: NSObject, MKAnnotation {
    var myCoordinate: CLLocationCoordinate2D
    var title: String?
    public var isHigh = false
    
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

