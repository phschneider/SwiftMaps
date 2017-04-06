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
    var trkseg = [Trkseg]()
    
    public var points: [CLLocationCoordinate2D]? {
        var points = [CLLocationCoordinate2D]()
        
        for segment in trkseg
        {
            for point in segment.trkpt
            {
                points.append(CLLocationCoordinate2DMake(point._lat as! CLLocationDegrees, point._lon as! CLLocationDegrees));
            }
        }
        return points
    }
}
