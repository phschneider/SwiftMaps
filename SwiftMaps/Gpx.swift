//
//  Gpx.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 06.04.17.
//  Copyright © 2017 phschneider.net. All rights reserved.
//

import Foundation
import EVReflection
import MapKit

class Gpx: EVObject {
    var _version: String?
    var _uid: String?
    var __name: String?
    var _xmlns: String?
    var _creator: String?
    var link: String?
    
    var trk : Trk?
    var wpt: [Wpt] = [Wpt]()
    
     func route() -> MKPolyline
     {
        var points = trk?.points
        var polyline = MKPolyline(coordinates: points!, count: (points?.count)!)
        return polyline
    }
}
