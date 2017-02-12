//
//  PicnicMapsViewController.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 15.11.16.
//  Copyright © 2016 phschneider.net. All rights reserved.
//

import Foundation
import MapKit

class PicnicMapsViewController: MapViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Picnic"
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
        
        Api().requestForBoundingBox("node[tourism=picnic_site]", boundingBox: boundingBoxString, mapView: self.mapView)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if (annotation is MKUserLocation) {
            //if annotation is not an MKPointAnnotation (eg. MKUserLocation),
            //return nil so map draws default view for it (eg. blue dot)...
            return nil
        }
        else if (annotation is NodeAnnotationView)
        {
            if ( (annotation as! NodeAnnotationView).node.isPeak())
            {
                let reuseId = "picnic"
                var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
                if (anView == nil)
                {
                    anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                    anView!.canShowCallout = true
                    //                    let label:UILabel = UILabel.init(frame: CGRectMake(0, 0, 20, 20))
                    //                    label.text = "🔼"
                    //                    anView?.addSubview(label)
                }
                return anView
            }
        }
        
        return nil
    }
    
}

