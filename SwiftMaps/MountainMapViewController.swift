//
//  MountainMapsViewController.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 23.09.16.
//  Copyright © 2016 phschneider.net. All rights reserved.
//

import Foundation
import MapKit

class MountainMapViewController: MapViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Mountains"
        self.mapView.mapType = MKMapType.HybridFlyover
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.alphaSlider.hidden = true
    }
    
    override func addTapped(){
        self.mapView .removeAnnotations(self.mapView.annotations)

        let bounding:[Double] = self.mapView.getBoundingBox(self.mapView.visibleMapRect)
        let boundingBoxString:String = String(format: "%.3f,%.3f,%.3f,%.3f", bounding[1],bounding[0],bounding[3],bounding[2])

        Api().requestForBoundingBox("node[natural=peak]", boundingBox: boundingBoxString, mapView: self.mapView)
    }

}

