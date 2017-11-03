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
    
    var gpx:Gpx?
    
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
        let stravaPersonalOverlay:PersonalStravaTileOverlay = PersonalStravaTileOverlay.init()
        let komootOverlay:KomootTileOverlay = KomootTileOverlay.init()
        self.mapView.addOverlays([osmOverlay,komootOverlay,stravaOverlay, stravaPersonalOverlay],level: .aboveLabels)
        
//        let overlay:MKTileOverlay = MKTileOverlay.init(URLTemplate:"http://globalheat.strava.com/tiles/cycling/color1/{z}/{x}/{y}.png")
//        overlay.canReplaceMapContent = false;
//        self.mapView.addOverlay(overlay, level: .AboveRoads)
        
        
        // TEST GPX / EVREFLECT
        if let filepath = Bundle.main.path(forResource: "AraSaarland400KmBrevet(v2)2017", ofType: "gpx") {
            do {
                let contents = try String(contentsOfFile: filepath)
                print(contents)
                self.gpx = Gpx(xmlString: contents)
                print(gpx?.trk)
                let line: MKPolyline = (gpx?.route())!
//                if (line)
//                {
                self.mapView.addOverlays([line], level:MKOverlayLevel.aboveLabels)
                var annotations:[MKAnnotation] = (gpx?.distanceAnnotations())!
                self.mapView.addAnnotations(annotations)
                
                annotations = (gpx?.wayPointAnnotations())!
                self.mapView.addAnnotations(annotations)
                
                for overlay in self.mapView.overlays
                {
                    if (overlay is MKPolyline)
                    {
                        let offset:CGFloat = 75
                        self.mapView.setVisibleMapRect(overlay.boundingMapRect, edgePadding: UIEdgeInsets(top: offset, left: offset, bottom: offset, right: offset), animated: true)
                    }
                }
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
        
        // TODO: DispatchTime anhand Kartenausschnitt 
        // TODO: DispatchTime anhand Anzahl Requests
        let dispatchTime = 60.0

        // TODO: Srings in Array und dann mittels dispatch durchgehen ...
        //        Api().requestForBoundingBox("way[landuse=cemetery]", boundingBox: boundingBoxString as NSString, mapView: self.mapView, gpx:self.gpx)
        //        Api().requestForBoundingBox("node[amenity=fountain]", boundingBox: boundingBoxString as NSString, mapView: self.mapView, gpx:self.gpx)
        
        // TODO:
        //        amenity=drinking_water -
        //        amenity=water_point -
        //        natural=spring -
        //        man_made=water_well -
        
        
        
        Api().requestForBoundingBox("node[natural=peak]", boundingBox: boundingBoxString as NSString, mapView: self.mapView, gpx:self.gpx)

        DispatchQueue.main.asyncAfter(deadline: .now() + dispatchTime) {
//            Api().requestForBoundingBox("node[tourism=picnic_site]", boundingBox: boundingBoxString as NSString, mapView: self.mapView, gpx:self.gpx)
        
            DispatchQueue.main.asyncAfter(deadline: .now() + dispatchTime) {
                Api().requestForBoundingBox("node[tourism=viewpoint]", boundingBox: boundingBoxString as NSString, mapView: self.mapView, gpx:self.gpx)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + dispatchTime) {
                    Api().requestForBoundingBox("node[amenity=shelter]", boundingBox: boundingBoxString as NSString, mapView: self.mapView, gpx:self.gpx)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + dispatchTime) {
//                        Api().requestForBoundingBox("node[amenity=bench]", boundingBox: boundingBoxString as NSString, mapView: self.mapView, gpx:self.gpx)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + dispatchTime) {
                            Api().requestForBoundingBox("node[amenity=fast_food]", boundingBox: boundingBoxString as NSString, mapView: self.mapView, gpx:self.gpx)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + dispatchTime) {
                                Api().requestForBoundingBox("node[amenity=restaurant]", boundingBox: boundingBoxString as NSString, mapView: self.mapView, gpx:self.gpx)
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + dispatchTime) {
                                    Api().requestForBoundingBox("node[amenity=cafe]", boundingBox: boundingBoxString as NSString, mapView: self.mapView, gpx:self.gpx)
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + dispatchTime) {
                                        Api().requestForBoundingBox("node[amenity=fuel]", boundingBox: boundingBoxString as NSString, mapView: self.mapView, gpx:self.gpx)
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + dispatchTime) {
                                            Api().requestForBoundingBox("node[shop=bakery]", boundingBox: boundingBoxString as NSString, mapView: self.mapView, gpx:self.gpx)
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + dispatchTime) {
                                                Api().requestForBoundingBox("node[shop=supermarket]", boundingBox: boundingBoxString as NSString, mapView: self.mapView, gpx:self.gpx)
                                                
                                                DispatchQueue.main.asyncAfter(deadline: .now() + dispatchTime) {
                                                    Api().requestForBoundingBox("node[cuisine=ice_cream]", boundingBox: boundingBoxString as NSString, mapView: self.mapView, gpx:self.gpx)
                                                    AlertController().showAlert("last Request")
                                                    
//                                                    DispatchQueue.main.asyncAfter(deadline: .now() + dispatchTime) {
//                                                        Api().requestForBoundingBox("node[highway=emergency_access_point]", boundingBox: boundingBoxString as NSString, mapView: self.mapView, gpx:self.gpx)
//                                                        AlertController().showAlert("last Request")
//                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        var annotations:[MKAnnotation] = (gpx?.distanceAnnotations())!
        self.mapView.addAnnotations(annotations)
        
        annotations = (gpx?.wayPointAnnotations())!
        self.mapView.addAnnotations(annotations)
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
                    anView?.image = UIImage(named:"peak")
                }
                else
                {
                    anView?.annotation = annotation
                }
                return anView
            }
            else if ( (annotation as! NodeAnnotationView).node.isPicnic())
            {
                let reuseId = "picnic"
                var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
                if (anView == nil)
                {
                    anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                    anView!.canShowCallout = true
                    anView?.image = UIImage(named:"picnic")
                   
                }
                else
                {
                    anView?.annotation = annotation
                }
                return anView
            }
            else if ( (annotation as! NodeAnnotationView).node.isBench())
            {
                let reuseId = "bench"
                var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
                if (anView == nil)
                {
                    anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                    anView!.canShowCallout = true
                    anView?.image = UIImage(named:"bench")
                    
                }
                else
                {
                    anView?.annotation = annotation
                }
                return anView
            }
            else if ( (annotation as! NodeAnnotationView).node.isCafe())
            {
                let reuseId = "cafe"
                var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
                if (anView == nil)
                {
                    anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                    anView!.canShowCallout = true
                    anView?.image = UIImage(named:"cafe")
                    
                }
                else
                {
                    anView?.annotation = annotation
                }
                return anView
            }
            else if ( (annotation as! NodeAnnotationView).node.isFuel())
            {
                let reuseId = "fuel"
                var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
                if (anView == nil)
                {
                    anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                    anView!.canShowCallout = true
                    anView?.image = UIImage(named:"fuel")
                    
                }
                else
                {
                    anView?.annotation = annotation
                }
                return anView
            }
            else if ( (annotation as! NodeAnnotationView).node.isBakery())
            {
                let reuseId = "bakery"
                var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
                if (anView == nil)
                {
                    anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                    anView!.canShowCallout = true
                    anView?.image = UIImage(named:"bakery")
                    
                }
                else
                {
                    anView?.annotation = annotation
                }
                return anView
            }
            else if ( (annotation as! NodeAnnotationView).node.isFastFood())
            {
                let reuseId = "fastfood"
                var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
                if (anView == nil)
                {
                    anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                    anView!.canShowCallout = true
                    anView?.image = UIImage(named:"fastfood")
                    
                }
                else
                {
                    anView?.annotation = annotation
                }
                return anView
            }
            else if ( (annotation as! NodeAnnotationView).node.isRestaurant())
            {
                let reuseId = "restaurant"
                var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
                if (anView == nil)
                {
                    anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                    anView!.canShowCallout = true
                    anView?.image = UIImage(named:"restaurant")
                    
                }
                else
                {
                    anView?.annotation = annotation
                }
                return anView
            }
            else if ( (annotation as! NodeAnnotationView).node.isSupermarket())
            {
                let reuseId = "supermarket"
                var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
                if (anView == nil)
                {
                    anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                    anView!.canShowCallout = true
                    anView?.image = UIImage(named:"supermarket")
                    
                }
                else
                {
                    anView?.annotation = annotation
                }
                return anView
            }
            else if ( (annotation as! NodeAnnotationView).node.isShelter())
            {
                let reuseId = "shelter"
                var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
                if (anView == nil)
                {
                    anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                    anView!.canShowCallout = true
                    anView?.image = UIImage(named:"shelter")
                    
                }
                else
                {
                    anView?.annotation = annotation
                }
                return anView
            }
            else if ( (annotation as! NodeAnnotationView).node.isViewpoint())
            {
                let reuseId = "viewpoint"
                var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
                if (anView == nil)
                {
                    anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                    anView!.canShowCallout = true
                    anView?.image = UIImage(named:"viewpoint")                    
                }
                else
                {
                    anView?.annotation = annotation
                }
                return anView
            }
            else if ( (annotation as! NodeAnnotationView).node.isIceCream())
            {
                let reuseId = "icecream"
                var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
                if (anView == nil)
                {
                    anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                    anView!.canShowCallout = true
                    anView?.image = UIImage(named:"icecream")
                }
                else
                {
                    anView?.annotation = annotation
                }
                return anView
            }
            else if ( (annotation as! NodeAnnotationView).node.isEmergencyAccessPoint())
            {
                let reuseId = "EmergencyAccessPoint"
                var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
                if (anView == nil)
                {
                    anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                    anView!.canShowCallout = true
                    anView?.image = UIImage(named:"emergency_access_point")
                }
                else
                {
                    anView?.annotation = annotation
                }
                return anView
            }
            else
            {
                let reuseId = "Std"
                var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
                if (anView == nil)
                {
                    anView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                    anView!.canShowCallout = true
                }
                else
                {
                    anView?.annotation = annotation
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
        
        else if (annotation is WayPointAnnotation)
        {
            var annotationView: MKAnnotationView = MKAnnotationView.init(annotation: annotation, reuseIdentifier: "WayPoint")
            annotationView.canShowCallout = false;
            
            let size:Int = 15
            var frame:CGRect = CGRect.zero
            frame.size = CGSize.init(width: size, height: size)
            
            var label:UILabel = UILabel.init(frame: annotationView.frame)
            label.frame = frame
            label.textAlignment = NSTextAlignment.center
//            label.text = annotation.title!
            label.backgroundColor = UIColor.red
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
