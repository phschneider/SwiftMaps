//
//  TrafficMapViewController.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 24.09.16.
//  Copyright © 2016 phschneider.net. All rights reserved.
//

import Foundation

class TrafficMapViewController: MapViewController {
    
    // MARK: View ...
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Traffice"
        self.mapView.mapType = MKMapType.Standard
    }
    
    override func viewWillAppear(animated: Bool) {
        //        locationManager.startUpdatingHeading()
        //        locationManager.startUpdatingLocation()
    }
    
    
    override func addTapped(){
        self.mapView .removeAnnotations(self.mapView.annotations)
        
        let bounding:[Double] = self.getBoundingBox(self.mapView.visibleMapRect)
        let boundingBoxString:String = String(format: "%.3f,%.3f,%.3f,%.3f", bounding[1],bounding[0],bounding[3],bounding[2])
        
        let searchStrings: [String] = ["highway=speed_camera", "highway=rest_area", "highway=services", "amenity=toilets"]
        
        for searchString in searchStrings {
            print(searchString)
            self.requestForBoundingBox(searchString, boundingBox: boundingBoxString)
        }
    }
}