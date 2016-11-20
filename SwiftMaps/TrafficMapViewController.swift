//
//  TrafficMapViewController.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 24.09.16.
//  Copyright © 2016 phschneider.net. All rights reserved.
//

import Foundation
import MapKit

class TrafficMapViewController: MapViewController {
    
    // MARK: View ...
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Traffic"
        self.mapView.mapType = MKMapType.Standard
    }
    
    override func viewWillAppear(animated: Bool) {
        //        locationManager.startUpdatingHeading()
        //        locationManager.startUpdatingLocation()
    }
    
    
    override func addTapped(){
        self.mapView .removeAnnotations(self.mapView.annotations)
        
        let bounding:[Double] = self.mapView.getBoundingBox(self.mapView.visibleMapRect)
        let boundingBoxString:String = String(format: "%.3f,%.3f,%.3f,%.3f", bounding[1],bounding[0],bounding[3],bounding[2])
        
        let searchStrings: [String] = ["node[highway=speed_camera]", "node[highway=rest_area]", "node[highway=services]", "node[amenity=toilets]"]
        
        for searchString in searchStrings {
            print(searchString)
            Api().requestForBoundingBox(searchString, boundingBox: boundingBoxString, mapView: self.mapView)
        }
    }
}