//
//  SingleTrailMapViewController.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 21.11.16.
//  Copyright © 2016 phschneider.net. All rights reserved.
//

import Foundation
import MapKit
import CoreData

class SingleTrailMapViewController: MapViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.addAlphaSlider()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Trails"
        self.mapView.mapType = MKMapType.standard

        // TEST GPX / EVREFLECT
        loadGpxFile()

        loadSavedPois()

//        MKPolyline *route = [track route];
//        [self.mapView addOverlay:route];

        let nc = NotificationCenter.default // Note that default is now a property, not a method call
        nc.addObserver(forName:Notification.Name(rawValue:"PoiSelectionChanged"),
                object:nil, queue:nil) {
            notification in
            // Handle notification
            self.loadSavedPois()
        }
    }

    private func loadGpxFile() {
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
    }

    private func loadSavedPois() {

        self.mapView .removeAnnotations(self.mapView.annotations)

        var zoomRect: MKMapRect = MKMapRectNull
        var annotations: [MKAnnotation] = []

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Poi")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sortOrder", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "enabled == true")

        do {
            let fetchedPois = try appDelegate.managedObjectContext.fetch(fetchRequest) as! [Poi]

            for poi in fetchedPois {

                let fetchRequestNodes = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataNode")
                fetchRequestNodes.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
                fetchRequestNodes.predicate = NSPredicate(format: "type == %@", String(format: "node[%@=%@]", poi.category!, poi.type!))

                do {
                    let fetchedNodes = try appDelegate.managedObjectContext.fetch(fetchRequestNodes) as! [CoreDataNode]
                    for coreDataNode in fetchedNodes {
                        let node = coreDataNode.toNode()
                        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(node._lat!), longitude: Double(node._lon!))
                        let loc = CLLocation.init(latitude: node._lat as! CLLocationDegrees, longitude: node._lon as! CLLocationDegrees)
                        let annotation = NodeAnnotationView.init(title: node.title(), coordinate: location, node: node)
                        let annotationPoint: MKMapPoint = MKMapPointForCoordinate(location);
                        annotations.append(annotation)
                        let pointRect: MKMapRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
                        if (MKMapRectIsNull(zoomRect)) {
                            zoomRect = pointRect;
                        } else {
                            zoomRect = MKMapRectUnion(zoomRect, pointRect);
                        }
                    }
                } catch {
                    fatalError("Failed to fetch nodes: \(error)")
                }

                if (annotations.count > 0) {
                    mapView.addAnnotations(annotations)
//            mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsetsMake(10,10,10,10), animated: true)
                }
            }
        }
        catch {
            fatalError("Failed to fetch pois: \(error)")
        }

        if (annotations.count > 0)
        {
            mapView.addAnnotations(annotations)
//            mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsetsMake(10,10,10,10), animated: true)
        }
    }


    override func showPoiViewController(){
//        addTapped()

        let poiViewController = PoiViewController.init()
        poiViewController.mapViewController = self
        let navController = UINavigationController.init(rootViewController: poiViewController)
        var frame = CGRect.init(x: 50, y: 75, width: self.view.frame.size.width-100, height:self.view.frame.size.height-150)

        let size = CGSize.init(width: self.view.frame.size.width/2 , height: self.view.frame.size.height/2)
        // iPAd
        if (UIDevice.current.userInterfaceIdiom == .pad)
        {
            navController.modalPresentationStyle = .formSheet;
            navController.preferredContentSize = size;
            self.present(navController, animated: true, completion: nil);
        }
        else
        {
            navController.willMove(toParentViewController: self);
            navController.view.frame = frame;
            // navController.view.layer.cornerRadius = 50;
            navController.view.center = self.view.center;
            navController.view.backgroundColor = UIColor.white;

            self.view.addSubview(navController.view);
            self.view .bringSubview(toFront: navController.view);
            self.addChildViewController(navController);

            navController.didMove(toParentViewController: self);
            // navController.view.layer.cornerRadius = 50;
            // navController.view.layer.shouldRasterize = true;
        }

        self.hideControls()
    }

    func addTapped(){
        self.mapView .removeAnnotations(self.mapView.annotations)

        
        // TODO: DispatchTime anhand Kartenausschnitt 
        // TODO: DispatchTime anhand Anzahl Requests
        let dispatchTime = 1.0
        let bounding:[Double] = self.mapView.getBoundingBox(self.mapView.visibleMapRect)
        let boundingBoxString:String = String(format: "%.3f,%.3f,%.3f,%.3f", bounding[1],bounding[0],bounding[3],bounding[2])

        // TODO: Srings in Array und dann mittels dispatch durchgehen ...
        //        Api().requestForBoundingBox("way[landuse=cemetery]", boundingBox: boundingBoxString as NSString, mapView: self.mapView, gpx:self.gpx)
        //        Api().requestForBoundingBox("node[amenity=fountain]", boundingBox: boundingBoxString as NSString, mapView: self.mapView, gpx:self.gpx)
        
        // TODO:
        //        amenity=drinking_water -
        //        amenity=water_point -
        //        natural=spring -
        //        man_made=water_well -
        

        // TODO 2: Request in DB Speichern
        // TODO 3: Response in DB Speichern um anzuzeigen
        // TODO 4: Requests im Debug Mode auf Karte anzeigen
        
        Api().requestForCurrentMapRect("node[natural=peak]", mapView: self.mapView, gpxTrack:self.gpx)

        DispatchQueue.main.asyncAfter(deadline: .now() + dispatchTime) {
//            Api().requestForMapRext("node[tourism=picnic_site]", boundingBox: boundingBoxString as NSString, mapView: self.mapView, gpx:self.gpx)
        
            DispatchQueue.main.asyncAfter(deadline: .now() + dispatchTime) {
                Api().requestForCurrentMapRect("node[tourism=viewpoint]", mapView: self.mapView, gpxTrack:self.gpx)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + dispatchTime) {
                    Api().requestForCurrentMapRect("node[amenity=shelter]", mapView: self.mapView, gpxTrack:self.gpx)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + dispatchTime) {
//                        Api().requestForMapRext("node[amenity=bench]", boundingBox: self.mapView.visibleMapRect, mapView: self.mapView, gpx:self.gpx)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + dispatchTime) {
                            Api().requestForCurrentMapRect("node[amenity=fast_food]", mapView: self.mapView, gpxTrack:self.gpx)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + dispatchTime) {
                                Api().requestForCurrentMapRect("node[amenity=restaurant]", mapView: self.mapView, gpxTrack:self.gpx)
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + dispatchTime) {
                                    Api().requestForCurrentMapRect("node[amenity=cafe]",  mapView: self.mapView, gpxTrack:self.gpx)
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + dispatchTime) {
                                        Api().requestForCurrentMapRect("node[amenity=fuel]", mapView: self.mapView, gpxTrack:self.gpx)
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + dispatchTime) {
                                            Api().requestForCurrentMapRect("node[shop=bakery]",mapView: self.mapView, gpxTrack:self.gpx)
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + dispatchTime) {
                                                Api().requestForCurrentMapRect("node[shop=supermarket]", mapView: self.mapView, gpxTrack:self.gpx)
                                                
                                                DispatchQueue.main.asyncAfter(deadline: .now() + dispatchTime) {
                                                    Api().requestForCurrentMapRect("node[cuisine=ice_cream]", mapView: self.mapView, gpxTrack:self.gpx)
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

        if (gpx != nil) {
            var annotations: [MKAnnotation] = (gpx?.distanceAnnotations())!
            self.mapView.addAnnotations(annotations)

            annotations = (gpx?.wayPointAnnotations())!
            self.mapView.addAnnotations(annotations)
        }
    }

    // MARK: - Map Delegate ...
    func mapView(_ mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if (annotation is MKUserLocation) {
            //if annotation is not an MKPointAnnotation (eg. MKUserLocation),
            //return nil so map draws default view for it (eg. blue dot)...
            return nil
        }
        else if (annotation is NodeAnnotationView)
        {
            let node = (annotation as! NodeAnnotationView).node
            if ( node?.isGeneric() )!
            {
                let reuseId = node?.type
                var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId!)
                if (anView == nil)
                {
                    anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                    anView!.canShowCallout = true
                    anView?.image = (annotation as! NodeAnnotationView).node.image()
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
