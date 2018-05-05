//
//  Trk.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 06.04.17.
//  Copyright © 2017 phschneider.net. All rights reserved.
//

import Foundation
import EVReflection
import MapKit

class Trk: EVObject {
    var name: String?
    var trkseg: [Trkseg] = [Trkseg]()

    required override init() {
        super.init()
        print("Trk init")
    }
        
    public var points: [CLLocationCoordinate2D]? {
        var points = [CLLocationCoordinate2D]()
        
        for segment in trkseg
        {
            print (segment)
//            for point in segment.trkpt
//            {
//                print (point)
                points.append(CLLocationCoordinate2DMake(segment._lat as! CLLocationDegrees, segment._lon as! CLLocationDegrees));
//            }
        }
        return points
    }
    
    public var locations: [CLLocation]? {
        var points = [CLLocation]()
        
        for segment in trkseg
        {
//            for point in segment.trkpt
//            {
                points.append(segment.location());
//            }
        }
        return points
    }
    
    public var distanceAnnotations: [DistanceAnnotation]? {
        var points = [DistanceAnnotation]()
        var alreadyAddedDistances = [String]()
        var location:CLLocation! = nil
        var tmplocation:CLLocation
        var distance:Double = 0.0

        for segment in trkseg
        {
//            for point in segment.trkpt
//            {
                tmplocation = segment.location()
                if (location != nil)
                {
                    distance = distance + location.distance(from: tmplocation)
                }
                let roundedDistance:Int = Int(distance/5000.0)
                if ((roundedDistance%1)==0)
                {
                    let distanceKey = String.init(format: "%d", roundedDistance*5 as! CVarArg)
                    if (!alreadyAddedDistances.contains(distanceKey))
                    {
                        points.append(DistanceAnnotation.init(coordinate: tmplocation.coordinate, title: distanceKey))
                        alreadyAddedDistances.append(distanceKey)
                    }
                }
                location = tmplocation
//            }
        }
        return points
    }
    
    func smallestDistanceTo(current: CLLocation) -> CLLocationDistance
    {
        var closestLocation: CLLocation?
        var smallestDistance: CLLocationDistance?
        for location in locations! {
            let distance = current.distance(from: location)
            if smallestDistance == nil || distance < smallestDistance!
            {
                closestLocation = location
                smallestDistance = distance
            }
        }
        return smallestDistance!
    }
}
