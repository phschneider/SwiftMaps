//
//  ViewController.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 09.07.16.
//  Copyright © 2016 phschneider.net. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate {
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    var locationButton: UIButton!
    
    var alphaSliderLeft: UISlider!
    var alphaSliderRight: UISlider!
    
    var alphaValueLeft : CGFloat = 1.0
    var alphaValueRight : CGFloat = 1.0
    
    // MARK: View ...
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if (CLLocationManager.locationServicesEnabled())
        {
            self.locationManager = CLLocationManager()
            // TODO - Delegate
//            self.locationManager.delegate = LocationManagerDelegate()
            locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.activityType = CLActivityType.automotiveNavigation
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            self.locationManager.startUpdatingHeading()

            // To complete the authorization process for enabling location services, add the following lines of code
            let status = CLLocationManager.authorizationStatus()
            if status == .notDetermined || status == .denied || status == .authorizedWhenInUse
            {
                // present an alert indicating location authorization required
                // and offer to take the user to Settings for the app via
                // UIApplication -openUrl: and UIApplicationOpenSettingsURLString
                //            self.locationManager.requestAlwaysAuthorization()
                self.locationManager.requestWhenInUseAuthorization()
            }
        }
        
        self.mapView = MKMapView(frame: self.view.frame)
        self.mapView.autoresizingMask = self.view.autoresizingMask
        self.mapView.delegate = self
        
        self.mapView.showsScale = true
        self.mapView.showsCompass = true;
        self.mapView.showsTraffic = true;
        self.mapView.showsBuildings = true;
        self.mapView.showsPointsOfInterest = true;
        
        self.mapView.mapType = MKMapType.standard
        self.mapView.showsUserLocation = true;
        self.mapView.userTrackingMode = MKUserTrackingMode.none
        
        self.view.addSubview(self.mapView)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(addTapped))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(organizeTapped))
        
        let nc = NotificationCenter.default // Note that default is now a property, not a method call
        nc.addObserver(forName:Notification.Name(rawValue:"TileSelectionChanged"),
                       object:nil, queue:nil) {
                        notification in
                        // Handle notification
                            self.showOverlays()
                        }
        
        nc.addObserver(forName:Notification.Name(rawValue:"TileSelectionClosed"),
                       object:nil, queue:nil) {
                        notification in
                            self.showControls()
                        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        //      TODO
        //        locationManager.startUpdatingHeading()
        //        locationManager.startUpdatingLocation()
        self.showOverlays()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.addLocationButton()
        
        if (self.locationManager != nil && CLLocationManager.locationServicesEnabled())
        {
            // 1. status is not determined
            if CLLocationManager.authorizationStatus() == .notDetermined
            {
                locationManager.requestWhenInUseAuthorization()
            }
                // 2. authorization were denied
            else if CLLocationManager.authorizationStatus() == .denied
            {
                AlertController().showAlert("Location services were previously denied. Please enable location services for this app in Settings.")
            }
                // 3. we do have authorization
            else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
            {
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if (self.locationManager != nil && CLLocationManager.locationServicesEnabled())
        {
            locationManager.stopUpdatingHeading()
            locationManager.stopUpdatingLocation()
        }
    }

    
    // MARK: Buttons
    func addLocationButton()
    {
        var frame = self.view.bounds;
        var originX = 15.0;
        var originY = self.mapView.frame.size.height - 50.0 - 15.0;
        let height = 48.0;
        
        frame.origin.y = frame.size.height - (44 + 20);
        frame.size.height -= frame.origin.y;
        //        frame.size.width = self.mapView.frame.size.width - ((5*originX) + (4*height) + (2*originX));
        frame.origin.x = ceil((self.mapView.frame.size.width - frame.size.width)/2);
        frame.size.height = CGFloat(height);
        
        self.locationButton = UIButton(type: UIButtonType.roundedRect)
        self.locationButton.backgroundColor = UIColor.white
        self.locationButton.frame = frame;
        self.locationButton.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        self.locationButton.addTarget(self, action: #selector(MapViewController.locationButtonTapped), for:.touchUpInside)
        
        self.view .addSubview(self.locationButton)
        self.updateLocationButtonTitle()
    }
    
    @objc func locationButtonTapped(){
        if (self.mapView.userTrackingMode == MKUserTrackingMode.none)
        {
            self.mapView.userTrackingMode = MKUserTrackingMode.follow
        }
        else if (self.mapView.userTrackingMode == MKUserTrackingMode.follow)
        {
            self.mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        }
        else //if (self.mapView.userTrackingMode == MKUserTrackingMode.FollowWithHeading)
        {
            self.mapView.userTrackingMode = MKUserTrackingMode.none;
        }
        self .updateLocationButtonTitle()
    }
    
    func updateLocationButtonTitle()
    {
        if (self.mapView.userTrackingMode == MKUserTrackingMode.none)
        {
            self.locationButton.setTitle("Follow", for: UIControlState())
        }
        else if (self.mapView.userTrackingMode == MKUserTrackingMode.follow)
        {
            self.locationButton.setTitle("Heading", for: UIControlState())
        }
        else //if (self.mapView.userTrackingMode == MKUserTrackingMode.FollowWithHeading)
        {
            self.locationButton.setTitle("None", for: UIControlState())
        }
    }
    
    func addAlphaSlider()
    {
        // Achtung, der Slider wird um 90° gedreht daher ist höhe = breite
        var frame = self.view.bounds;
        let height = 48.0;
        
        if (self.view.bounds.size.width > self.view.bounds.size.height)
        {
            // Landscape = 0,0, 736, 414
            frame.origin.y = ceil(frame.size.height / 2) // - (44 + 20);
            frame.size.width = min(self.view.bounds.size.width,self.view.bounds.size.height) - frame.origin.y
            frame.size.height -= frame.origin.y;
            frame.origin.x = ceil(frame.size.width / 2) * (-1) + 40;
            frame.size.height = CGFloat(height);
        }
        else
        {
            // Landscape = 0,0, 736, 414
            frame.origin.y = ceil(frame.size.height / 2) // - (44 + 20);
            frame.size.height -= frame.origin.y;
            frame.origin.x = ceil(frame.size.width / 2) * (-1) + 40;
            frame.size.height = CGFloat(height);
        }
        
        // Landscape = -328, 207, 736,48
        // Mit min ) -167, 207, 414, 48
        self.alphaSliderLeft = UISlider()
        self.alphaSliderLeft.backgroundColor = UIColor.white
        self.alphaSliderLeft.value = Float(alphaValueLeft)
        self.alphaSliderLeft.frame = frame;
        
        self.alphaSliderLeft.autoresizingMask = [.flexibleHeight, .flexibleBottomMargin, .flexibleTopMargin]
        
        self.alphaSliderLeft.removeConstraints(self.alphaSliderLeft.constraints)
        self.alphaSliderLeft.translatesAutoresizingMaskIntoConstraints = true
        self.alphaSliderLeft.addTarget(self, action: #selector(MapViewController.sliderValueChanged(sender:)), for:.valueChanged)
        self.alphaSliderLeft.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        self.view .addSubview(self.alphaSliderLeft)
        
        self.alphaSliderRight = UISlider()
        self.alphaSliderRight.backgroundColor = UIColor.white
        self.alphaSliderRight.value = Float(alphaValueRight)
        if (self.view.bounds.size.width > self.view.bounds.size.height)
        {
            frame.origin.x = ceil((frame.size.width*2) ) + 20;
        }
        else
        {
            frame.origin.x = ceil(frame.size.width / 2) - 40;
        }
        self.alphaSliderRight.frame = frame;
        
        self.alphaSliderRight.autoresizingMask = [.flexibleHeight, .flexibleBottomMargin, .flexibleTopMargin, .flexibleLeftMargin]
        
        self.alphaSliderRight.removeConstraints(self.alphaSliderRight.constraints)
        self.alphaSliderRight.translatesAutoresizingMaskIntoConstraints = true
        self.alphaSliderRight.addTarget(self, action: #selector(MapViewController.sliderValueChanged(sender:)), for:.valueChanged)
        self.alphaSliderRight.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        self.view .addSubview(self.alphaSliderRight)
    }
    
    @objc func sliderValueChanged(sender:UISlider)
    {
        if (sender == self.alphaSliderLeft)
        {
            alphaValueLeft = CGFloat(sender.value)
        //        self.alphaSlider.value
        }
        else if (sender == self.alphaSliderRight)
        {
            alphaValueRight = CGFloat(sender.value)
        }
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
        mapView.addOverlays(overlays)
    }
    
    @objc func organizeTapped()
    {
        let tileViewController = TileViewController.init()
        let navController = UINavigationController.init(rootViewController: tileViewController)
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
    
    
    @objc func addTapped(){
        self.mapView .removeAnnotations(self.mapView.annotations)
        
        //        >      4             1            2               3
        //            > Baden-Württemberg:
        //        > 49.7913749328 7.5113934084 47.5338000528 10.4918239143
        
        let bw = "7.5113934084,47.5338000528,10.4918239143,49.7913749328"
        
        //        >
        //        > Bayern:
        //        > 50.5644529365 8.9771580802 47.2703623267 13.8350427083
        
        let bayern = "8.9771580802,47.2703623267,13.8350427083,50.5644529365"
        
        let austria = "10.2049255371,46.8808457057,11.3200378418,47.5301837827"
        
        let lichtenstein = "9.4633483887,46.9108747024,10.2571105957,47.613569754"
        
        //        >
        //        > Berlin:
        //        > 52.6697240587 13.0882097323 52.3418234221 13.7606105539
        //        >
        //        > Brandenburg:
        //        > 53.5579500214 11.2681664447 51.3606627053 14.7647105012
        //        >
        //        > Bremen:
        //        > 53.6061664164 8.4813576818 53.0103701114 8.9830477728
        //        >
        //        > Hamburg:
        //        > 53.9644376366 8.4213643278 53.3949251389 10.3242585128
        //        >
        //        > Hessen:
        //        > 51.6540496066 7.7731704009 49.3948229196 10.2340156149
        //        >
        //        > Mecklenburg-Vorpommern:
        //        > 54.6849886830 10.5932460856 53.1158637944 14.4122799503
        //        >
        //        > Niedersachsen:
        //        > 53.8941514415 6.6545841239 51.2954150799 11.59769814
        //        >
        //        > Nordrhein-Westfalen:
        //        > 52.5310351488 5.8659988131 50.3226989435 9.4476584861
        //        >
        //        > Rheinland-Pfalz:
        //        > 50.9404435711 6.1173598760 48.9662745077 8.5084754437
        
        let pfalz = "6.1173598760,48.9662745077,8.5084754437,50.9404435711"
        
        //        >
        //        > Saarland:
        //        > 49.6393467247 6.3584695643 49.1130992988 7.4034901078
        //        >      4             1            2               3
        let saarland = "6.3584695643,49.1130992988,7.4034901078,49.6393467247"
        
        //        > Sachsen:
        //        > 51.6831408995 11.8723081683 50.1715419914 15.0377433357
        //        >
        //        > Sachsen-Anhalt:
        //        > 53.0421316033 10.5614755400 50.9379979829 13.1865600846
        //        >
        //        > Schleswig-Holstein:
        //        > 55.0573747014 7.8685145620 53.3590675115 11.3132037822
        //        >
        //        > Thüringen:
        //        > 51.6490678544 9.8778443239 50.2042330625 12.6531964048
        
        // bbox = min Längengrad, min Breitengrad, max Längengrad, max Breitengrad
        
        // http://boundingbox.klokantech.com => auf csv/raw stellen
        
        //        [[[6.8997573853,49.2041400138],[6.8997573853,49.2993821679],[7.0501327515,49.2993821679],[7.0501327515,49.2041400138],[6.8997573853,49.2041400138]]]
        
       
        let boundingBoxes: [String] = [saarland ] //, pfalz, bw, austria, lichtenstein]
//        var searchStrings: [String] = ["highway=speed_camera", "highway=rest_area", "highway=services", "amenity=toilets"]
        let searchStrings: [String] = ["highway=speed_camera", "highway=rest_area", "highway=services"] //, "amenity=toilets"]
        
        for boundingBox in boundingBoxes {
            print(boundingBox)
            for searchString in searchStrings {
                print(searchString)
                Api().requestForBoundingBox(searchString, boundingBox: boundingBox as NSString, mapView: self.mapView)
            }
        }
    }
    
    
    // Mark: Helper
    func showOverlays()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let employeesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Tile")
        let sortDescriptor = NSSortDescriptor(key: "sortOrder", ascending: true)
        employeesFetch.sortDescriptors = [sortDescriptor]
        
        var overlays = self.mapView.overlays
        self.mapView.removeOverlays(overlays)
        overlays.removeAll()
        
        employeesFetch.predicate = NSPredicate(format: "enabled == true")
        do {
            let fetchedEmployees = try appDelegate.managedObjectContext.fetch(employeesFetch) as! [Tile]
            
            for tile in fetchedEmployees {
                
                if let anyObj : TileOverlay.Type = NSClassFromString("SingleTrailMaps."+tile.classFileName!) as! TileOverlay.Type
                {
                    
                    if (tile.classFileName == "CoreDataTileOverlay")
                    {
                        let instance:CoreDataTileOverlay
                        
                        let scheme = (tile.useHttps==false) ? "http://" : "https://"
                        let url:String = scheme + tile.url! + "/{z}/{x}/{y}.png"
                        
                        instance = CoreDataTileOverlay.init(urlTemplate:url)
                        instance.tileName = tile.name!
                        instance.tileUseLoadbalancing = tile.useLoadbalancing
                        
                        overlays.append(instance)
                    }
                    else
                    {
                        let instance = anyObj.init()
                        overlays.append(instance)
                    }
                }
                else
                {
                    print ("not found: "+tile.name!)
                }
                
            }
            
            // TODO: CoreData TileOverlay ...
            self.mapView.addOverlays(overlays,level: .aboveLabels)
            
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }
    
    
    func hideControls()
    {
        self.alphaSliderLeft.alpha = 0.0;
        self.alphaSliderRight.alpha = 0.0;
        self.locationButton.alpha = 0.0;
    }
    
    func showControls()
    {
        self.alphaSliderLeft.alpha = 1.0;
        self.alphaSliderRight.alpha = 1.0;
        self.locationButton.alpha = 1.0;
    }
    
    // MARK: Helper
//    func selectAllVisibleAnnotation()
//    {
//        for object in self.mapView.annotations(in: self.mapView.visibleMapRect)
//        {
//            if (object .conforms(to: MKAnnotation))
//            {
//                self.mapView.selectAnnotation(object as! MKAnnotation, animated: false)
//            }
//        }
//    }
    
    
    // MARK: MapView
//    func mapView(mapView: MKMapView,didSelectAnnotationView view: MKAnnotationView)
//    {
//        if ((view.annotation?.isKindOfClass(NodeAnnotationView)) != nil)
//        {
//            var annotation : NodeAnnotationView
//            annotation = (view.annotation as? NodeAnnotationView)!
//            
//            var node: Node
//            node = annotation.node
//            
//            var detailViewController: DetailViewController
//            detailViewController = DetailViewController.init(node: node)
//            
//            self.navigationController!.pushViewController(detailViewController, animated: true)
//        }
//    }
    
    
//    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
////        if !(annotation is CustomPointAnnotation) {
////            return nil
////        }
////        
//        let reuseId = "test"
//        
//        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
//        if anView == nil {
//            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//            anView!.canShowCallout = true
//            
//            anView!.rightCalloutAccessoryView = UIButton.init(type: .InfoDark) as UIButton
//            
//        }
//        else {
//            anView!.annotation = annotation
//        }
//        
//        
////        let cpa = annotation as CustomPointAnnotation
////        anView.image = UIImage(named:cpa.imageName)
//        
//        return anView
//    }
    
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        
//        if control == view.rightCalloutAccessoryView {
//            print("Disclosure Pressed! \( view.annotation!.subtitle)")
//        }
//        
//    }
//   
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if (overlay is MKCircle)
        {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.strokeColor = UIColor.red
            circleRenderer.lineWidth = 1.0
            return circleRenderer
        }
            
        if (overlay is MKPolygon)
        {
            let renderer = MKPolygonRenderer(polygon: overlay as! MKPolygon)
            renderer.fillColor = UIColor.orange.withAlphaComponent(0.25)
            renderer.strokeColor = UIColor.orange.withAlphaComponent(0.5)
            renderer.lineWidth = 2
            return renderer
        }
            
            
        else if (overlay is MKTileOverlay)
        {
            let renderer = MKTileOverlayRenderer.init(tileOverlay: (overlay as! MKTileOverlay))
            renderer.alpha = 1.0;
            if (overlay is StravaPersonalTileOverlay)
            {
                
            }
            else if (overlay is StravaTileOverlay)
            {
                renderer.alpha = alphaValueLeft
            }
            else if (overlay is KomootTileOverlay)
            {
                renderer.alpha = alphaValueRight;
            }
            return renderer
        }
            
        else if (overlay is MKPolyline)
        {
            // draw the track
            let polyLine = overlay
            let polyLineRenderer = MKPolylineRenderer(overlay: polyLine)
            polyLineRenderer.strokeColor = UIColor(red: CGFloat(arc4random()) / CGFloat(UInt32.max),green: CGFloat(arc4random()) / CGFloat(UInt32.max), blue:  CGFloat(arc4random()) / CGFloat(UInt32.max), alpha: 1.0)
            polyLineRenderer.lineWidth = 2.0
            
            return polyLineRenderer
        }
            
        else
        {
            return MKOverlayRenderer.init(overlay: overlay)
        }
    }
}

