//
//  NatureMapViewController.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 05.03.17.
//  Copyright © 2017 phschneider.net. All rights reserved.
//

import Foundation
import MapKit

class NatureMapViewController: MapViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Nature"
        self.mapView.mapType = MKMapType.hybridFlyover
    }
    
    
    override func addTapped(){
        self.mapView .removeAnnotations(self.mapView.annotations)
        
        let bounding:[Double] = self.mapView.getBoundingBox(self.mapView.visibleMapRect)
        let boundingBoxString:String = String(format: "%.3f,%.3f,%.3f,%.3f", bounding[1],bounding[0],bounding[3],bounding[2])
        
        Api().requestForBoundingBox("way[leisure=nature_reserve]", boundingBox: boundingBoxString as NSString, mapView: self.mapView)
    }
    
}
