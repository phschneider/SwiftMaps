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
        
        let osmOverlay:MapBoxRunBikeHikeTileOverlay = MapBoxRunBikeHikeTileOverlay.init()
//        let osmOverlay:MKTileOverlay = MKTileOverlay.init(URLTemplate:"https://api.mapbox.com/v4/mapbox.run-bike-hike/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoicGhzY2huZWlkZXIiLCJhIjoiajRrY3hyUSJ9.iUqFM9KNijSRZoI-cHkyLw")
//        osmOverlay.canReplaceMapContent = true;
        
        
//        let osmOverlay:MKTileOverlay = MKTileOverlay.init(URLTemplate:"https://a.tile.opentopomap.org/{z}/{x}/{y}.png")
//        osmOverlay.canReplaceMapContent = true;

//        let osmOverlay:MKTileOverlay = MKTileOverlay.init(URLTemplate:"https://c.tile.hosted.thunderforest.com/komoot-2/{z}/{x}/{y}.png")
//        osmOverlay.canReplaceMapContent = true;

        
        let stravaOverlay:StravaTileOverlay = StravaTileOverlay.init()        
        self.mapView.addOverlays([osmOverlay,stravaOverlay],level: .aboveLabels)
        
//        let overlay:MKTileOverlay = MKTileOverlay.init(URLTemplate:"http://globalheat.strava.com/tiles/cycling/color1/{z}/{x}/{y}.png")
//        overlay.canReplaceMapContent = false;
//        self.mapView.addOverlay(overlay, level: .AboveRoads)
        
        
        // TEST GPX / EVREFLECT
        if let filepath = Bundle.main.path(forResource: "AraSaarland200KmBrevet2017", ofType: "gpx") {
            do {
                let contents = try String(contentsOfFile: filepath)
                print(contents)
                let gpx = Gpx(xmlString: contents)
                print(gpx?.trk)
                let line: MKPolyline = (gpx?.route())!
//                if (line)
//                {
                self.mapView.addOverlays([line], level:MKOverlayLevel.aboveLabels)
                var annotations:[MKAnnotation] = (gpx?.distanceAnnotations())!
                self.mapView.addAnnotations(annotations)
//                }
            } catch {
                // contents could not be loaded
            }
        } else {
            // example.txt not found!
        }

        
//        MKPolyline *route = [track route];
//        [self.mapView addOverlay:route];
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
        else if (annotation is DistanceAnnotation)
        {
            var annotationView: MKAnnotationView = MKAnnotationView.init(annotation: annotation, reuseIdentifier: "Distance")
            annotationView.canShowCallout = false;
            
            let size:Int = 15
            var frame:CGRect = CGRect.zero
            frame.size = CGSize.init(width: size, height: size)
            
            var label:UILabel = UILabel.init(frame: annotationView.frame)
            label.frame = frame
            label.textAlignment = NSTextAlignment.center
            label.text = annotation.title!
            label.backgroundColor = UIColor.yellow
            label.adjustsFontSizeToFitWidth = true
            label.font = UIFont.systemFont(ofSize: 10)
            label.clipsToBounds = true
            label.textColor = UIColor.black
            label.layer.borderColor = UIColor.black.cgColor
            label.layer.cornerRadius = frame.size.width/2
            label.layer.borderWidth = 1.0
            label.center = annotationView.center
            annotationView .addSubview(label)
            return annotationView
        }

        return nil
    }
    
}
