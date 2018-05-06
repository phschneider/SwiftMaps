//
//  Trkseg.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 06.04.17.
//  Copyright © 2017 phschneider.net. All rights reserved.
//

import Foundation
import EVReflection

class Trkseg: EVObject {
//    var trkpt: [Trkpt] = [Trkpt]()

    // Anstatt trkpt!?
    var ele: String?
    var time: String?

    var _lat: NSNumber?
    var _lon: NSNumber?
    var _location: CLLocation?
    func location () ->CLLocation
    {
        if (self._location == nil)
        {
            var finalDate =  NSDate.init() as Date
            if (time != nil)
            {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                let date = dateFormatter.date(from:time!)!
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
                finalDate = calendar.date(from:components)!
            }
            
            let coord =  CLLocationCoordinate2DMake(_lat as! CLLocationDegrees, _lon as! CLLocationDegrees)
            let alt = Double(ele!)
            
            //self._location = CLLocation.init(latitude: _lat as! CLLocationDegrees, longitude: _lon as! CLLocationDegrees)
            self._location = CLLocation.init(coordinate:coord, altitude: alt!, horizontalAccuracy: 0, verticalAccuracy: 0.0, timestamp: finalDate)
        }
        
        return _location!
        
    }
}
