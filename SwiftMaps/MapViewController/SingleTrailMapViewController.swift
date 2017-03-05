//
//  SingleTrailMapViewController.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 21.11.16.
//  Copyright © 2016 phschneider.net. All rights reserved.
//

import Foundation
import MapKit

class SingleTrailMapViewController: MapViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.addAlphaSlider()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Trails"
        self.mapView.mapType = MKMapType.standard
        
        let osmOverlay:MKTileOverlay = MKTileOverlay.init(urlTemplate:"https://api.mapbox.com/v4/mapbox.run-bike-hike/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoicGhzY2huZWlkZXIiLCJhIjoiajRrY3hyUSJ9.iUqFM9KNijSRZoI-cHkyLw")
        osmOverlay.canReplaceMapContent = true;
//        let osmOverlay:MKTileOverlay = MKTileOverlay.init(URLTemplate:"https://api.mapbox.com/v4/mapbox.run-bike-hike/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoicGhzY2huZWlkZXIiLCJhIjoiajRrY3hyUSJ9.iUqFM9KNijSRZoI-cHkyLw")
//        osmOverlay.canReplaceMapContent = true;
        
        
//        let osmOverlay:MKTileOverlay = MKTileOverlay.init(URLTemplate:"https://a.tile.opentopomap.org/{z}/{x}/{y}.png")
//        osmOverlay.canReplaceMapContent = true;

//        let osmOverlay:MKTileOverlay = MKTileOverlay.init(URLTemplate:"https://c.tile.hosted.thunderforest.com/komoot-2/{z}/{x}/{y}.png")
//        osmOverlay.canReplaceMapContent = true;

        
        let stravaOverlay:TileOverlay = TileOverlay.init(urlTemplate:"http://globalheat.strava.com/tiles/cycling/color1/{z}/{x}/{y}.png")
        stravaOverlay.canReplaceMapContent = false;
        self.mapView.addOverlays([osmOverlay,stravaOverlay],level: .aboveLabels)
        
//        let overlay:MKTileOverlay = MKTileOverlay.init(URLTemplate:"http://globalheat.strava.com/tiles/cycling/color1/{z}/{x}/{y}.png")
//        overlay.canReplaceMapContent = false;
//        self.mapView.addOverlay(overlay, level: .AboveRoads)
    }
    
    override func addTapped(){
        self.mapView .removeAnnotations(self.mapView.annotations)
        
        let bounding:[Double] = self.mapView.getBoundingBox(self.mapView.visibleMapRect)
        let boundingBoxString:String = String(format: "%.3f,%.3f,%.3f,%.3f", bounding[1],bounding[0],bounding[3],bounding[2])
        
//        Api().requestForBoundingBox("node[tourism=picnic_site]", boundingBox: boundingBoxString, mapView: self.mapView)
    }
    
    func mapView(_ mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
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
                var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
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
