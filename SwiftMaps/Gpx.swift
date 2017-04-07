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
    
    func distanceAnnotations() -> [DistanceAnnotation]
    {
        var points:[DistanceAnnotation] = (trk?.distanceAnnotations)!
        return points
    }
    
    func smallesDistance(current: CLLocation) -> CLLocationDistance
    {
        return (trk?.smallestDistanceTo(current: current))!
    }
    
    func wayPointAnnotations() -> [WayPointAnnotation]
    {
        var points = [WayPointAnnotation]()
        for point in wpt
        {
            let tmpLocation = CLLocation.init(latitude: point._lat as! CLLocationDegrees, longitude: point._lon as! CLLocationDegrees)
            points.append(WayPointAnnotation.init(coordinate: tmpLocation.coordinate, title: point.name!))
        }
        return points
    }
}
