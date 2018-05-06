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
         print("route")
        let points = trk?.points
        let polyline = MKPolyline(coordinates: points!, count: (points?.count)!)
        return polyline
    }
    
    func distanceAnnotations() -> [DistanceAnnotation]
    {
        print("distanceAnnotations")
        let points:[DistanceAnnotation] = (trk?.distanceAnnotations)!
        return points
    }
    
    func smallesDistance(current: CLLocation) -> CLLocationDistance
    {
        return (trk?.smallestDistanceTo(current: current))!
    }
    
    func wayPointAnnotations() -> [WayPointAnnotation]
    {
        print("wayPointAnnotations")
        var points = [WayPointAnnotation]()
        for point in wpt
        {
            let tmpLocation = CLLocation.init(latitude: point._lat as! CLLocationDegrees, longitude: point._lon as! CLLocationDegrees)
            points.append(WayPointAnnotation.init(coordinate: tmpLocation.coordinate, title: point.name!))
        }
        return points
    }

    func high() -> [HighLowAnnotation]
    {
        print("high")
        var points = [HighLowAnnotation]()
        var high:CLLocation?
        for point in (trk?.locations)!
        {
            if (high == nil)
            {
                high = point
            }
            else if (Double(point.altitude) - Double((high?.altitude)!) > 0)
            {
                print("point: \(point.altitude)")
                print("high: \(high?.altitude)")

                high = point
            }
        }
//        points.append(HighLowAnnotation.init(coordinate: (high?.coordinate)!, title: String(format: "%.fm",(high?.altitude)!)))
        let annotation = HighLowAnnotation.init(coordinate: (high?.coordinate)!, title: String(format: "%.f",(high?.altitude)!))
        annotation.isHigh = true
        points.append(annotation)
        return points
    }
    
    func highLow() -> [HighLowAnnotation]
    {
        print("highLow")
        var points = [HighLowAnnotation]()
        var high:CLLocation?
        var low:CLLocation?
        for point in (trk?.locations)!
        {
            if (low == nil)
            {
                low = point
            }
            
            if (high == nil)
            {
                high = point
            }
            
            if (Double(point.altitude) - Double((high?.altitude)!) > 0)
            {
                print("point: \(point.altitude)")
                print("high: \(high?.altitude)")
                
                high = point
            }
            
            if (Double(point.altitude) - Double((low?.altitude)!) < 0)
            {
                print("point: \(point.altitude)")
                print("low: \(high?.altitude)")
                
                low = point
            }
        }
        let annotation = HighLowAnnotation.init(coordinate: (high?.coordinate)!, title: String(format: "%.f",(high?.altitude)!))
        annotation.isHigh = true
        points.append(annotation)
        points.append(HighLowAnnotation.init(coordinate: (low?.coordinate)!, title: String(format: "%.f",(low?.altitude)!)))

        return points
    }
    
    func low() -> [HighLowAnnotation]
    {
        print("high")
        var points = [HighLowAnnotation]()
        var high:CLLocation?
        for point in (trk?.locations)!
        {
            if (high == nil)
            {
                high = point
            }
            else if (Double(point.altitude) - Double((high?.altitude)!) < 0)
            {
                print("point: \(point.altitude)")
                print("high: \(high?.altitude)")
                
                high = point
            }
        }
        points.append(HighLowAnnotation.init(coordinate: (high?.coordinate)!, title: String(format: "%.f",(high?.altitude)!)))
        return points
    }
    
    func distance() -> CLLocationDistance
    {
        var distance = 0.0
        var lastLocation:CLLocation?
        
        for location in (trk?.locations)!
        {
            if (lastLocation != nil)
            {
                distance += location.distance(from: lastLocation!)
            }
            lastLocation = location
        }
        return distance
    }

    // TODO: Min Höhe (Wert X bei KM Y)
    // TODO: MAx Höhe (Wert X bei KM Y)

    // TODO: Anstieg 1 ...
    // TODO: Anstieg 2 ...
}
