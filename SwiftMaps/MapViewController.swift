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
import Alamofire
//import SWXMLHash
import AlamofireXmlToObjects

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    var locationButton: UIButton!
    
    // MARK: View ...
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if (CLLocationManager.locationServicesEnabled())
        {
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
            locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.activityType = CLActivityType.AutomotiveNavigation
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            self.locationManager.startUpdatingHeading()
        }
        
//        // To complete the authorization process for enabling location services, add the following lines of code
        let status = CLLocationManager.authorizationStatus()
        if status == .NotDetermined || status == .Denied || status == .AuthorizedWhenInUse {
            // present an alert indicating location authorization required
            // and offer to take the user to Settings for the app via
            // UIApplication -openUrl: and UIApplicationOpenSettingsURLString
//            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        self.mapView = MKMapView(frame: self.view.frame)
        self.mapView.autoresizingMask = self.view.autoresizingMask
        self.mapView.delegate = self
        
        self.mapView.showsScale = true
        self.mapView.showsCompass = true;
        self.mapView.showsTraffic = true;
        self.mapView.showsBuildings = true;
        self.mapView.showsPointsOfInterest = true;
        
        self.mapView.mapType = MKMapType.Standard
        self.mapView.showsUserLocation = true;
        self.mapView.userTrackingMode = MKUserTrackingMode.None
        
        self.view.addSubview(self.mapView)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: #selector(addTapped))

//        var frame: CGRect!
        setupData()
    }
    
    override func viewWillAppear(animated: Bool) {
        //        locationManager.startUpdatingHeading()
        //        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.addLocationButton()
        
        // 1. status is not determined
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
            // 2. authorization were denied
        else if CLLocationManager.authorizationStatus() == .Denied {
            showAlert("Location services were previously denied. Please enable location services for this app in Settings.")
        }
            // 3. we do have authorization
        else if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        locationManager.stopUpdatingHeading()
        locationManager.stopUpdatingLocation()
    }

    
    // MARK: Buttons
    func addLocationButton()
    {
        var frame = self.view.bounds;
        var originX = 15.0;
        var originY = self.mapView.frame.size.height - 50.0 - 15.0;
        var height = 48.0;
        
        frame.origin.y = frame.size.height - (44 + 20);
        frame.size.height -= frame.origin.y;
        //        frame.size.width = self.mapView.frame.size.width - ((5*originX) + (4*height) + (2*originX));
        frame.origin.x = ceil((self.mapView.frame.size.width - frame.size.width)/2);
        frame.size.height = CGFloat(height);
        
        self.locationButton = UIButton(type: UIButtonType.RoundedRect)
        self.locationButton.backgroundColor = UIColor.whiteColor()
        self.locationButton.frame = frame;
        self.locationButton.autoresizingMask = [.FlexibleWidth, .FlexibleTopMargin]
        self.locationButton.addTarget(self, action: Selector("locationButtonTapped"), forControlEvents:.TouchUpInside)
        
        self.view .addSubview(self.locationButton)
        self.updateLocationButtonTitle()
    }
    
    func locationButtonTapped(){
        if (self.mapView.userTrackingMode == MKUserTrackingMode.None)
        {
            self.mapView.userTrackingMode = MKUserTrackingMode.Follow
        }
        else if (self.mapView.userTrackingMode == MKUserTrackingMode.Follow)
        {
            self.mapView.userTrackingMode = MKUserTrackingMode.FollowWithHeading
        }
        else //if (self.mapView.userTrackingMode == MKUserTrackingMode.FollowWithHeading)
        {
            self.mapView.userTrackingMode = MKUserTrackingMode.None;
        }
        self .updateLocationButtonTitle()
    }
    
    func updateLocationButtonTitle()
    {
        if (self.mapView.userTrackingMode == MKUserTrackingMode.None)
        {
            self.locationButton.setTitle("Follow", forState: UIControlState.Normal)
        }
        else if (self.mapView.userTrackingMode == MKUserTrackingMode.Follow)
        {
            self.locationButton.setTitle("Heading", forState: UIControlState.Normal)
        }
        else //if (self.mapView.userTrackingMode == MKUserTrackingMode.FollowWithHeading)
        {
            self.locationButton.setTitle("None", forState: UIControlState.Normal)
        }
    }
    
    func addTapped(){
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
                self.requestForBoundingBox(searchString, boundingBox: boundingBox)
            }
        }
        
        //        self.requestForBoundingBox(searchString, boundingBox: pfalz)
        //        self.requestForBoundingBox(searchString, boundingBox: bw)
        
        
//        self.requestForBoundingBox(searchString, boundingBox: saarland)
        //        self.requestForBoundingBox(searchString, boundingBox: pfalz)
        //        self.requestForBoundingBox(searchString, boundingBox: bw)
    
    }
    
    // MARK: Bounding Box
    // http://www.softwarepassion.com/how-to-get-geographic-coordinates-of-the-visible-mkmapview-area-in-ios/
    func getCoordinateFromMapRectanglePoint(x:Double, y:Double) -> CLLocationCoordinate2D
    {
        return MKCoordinateForMapPoint(MKMapPointMake(x, y))
    }
    
    func getNECoordinate(mapRect: MKMapRect) -> CLLocationCoordinate2D
    {
        return self.getCoordinateFromMapRectanglePoint(MKMapRectGetMaxX(mapRect),y:mapRect.origin.y);
    }
    
    func getNWCoordinate(mapRect: MKMapRect) -> CLLocationCoordinate2D
    {
        return self.getCoordinateFromMapRectanglePoint(MKMapRectGetMinX(mapRect),y:mapRect.origin.y);
    }
    
    func getSECoordinate(mapRect: MKMapRect) -> CLLocationCoordinate2D
    {
        return self.getCoordinateFromMapRectanglePoint(MKMapRectGetMaxX(mapRect),y:MKMapRectGetMaxY(mapRect));
    }
    
    func getSWCoordinate(mapRect: MKMapRect) -> CLLocationCoordinate2D
    {
        return self.getCoordinateFromMapRectanglePoint(mapRect.origin.x,y:MKMapRectGetMaxY(mapRect));
    }
    
    func getBoundingBox(mapRect: MKMapRect) -> [Double]
    {
        let bottomLeft:CLLocationCoordinate2D = self.getSWCoordinate(mapRect)
        let topRight:CLLocationCoordinate2D = self.getNECoordinate(mapRect)
        
        return [bottomLeft.latitude, bottomLeft.longitude, topRight.latitude, topRight.longitude]
    }
    
    func requestForBoundingBox(searchString: String, boundingBox: NSString)
    {
        
        var urlString : String
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let url = NSURL(fileURLWithPath: path)
            let filePath = url.URLByAppendingPathComponent("sample.xml").path!
            let fileManager = NSFileManager.defaultManager()
            if fileManager.fileExistsAtPath(filePath) {
                print("FILE AVAILABLE %@",filePath)
                urlString = String(format:"file://%@",filePath)
            } else {
                print("FILE NOT AVAILABLE")
                urlString = String(format:"http://overpass.osm.rambler.ru/cgi/xapi_meta?node[%@][bbox=%@]", searchString,boundingBox)
            }
            #else
                urlString = String(format:"http://overpass.osm.rambler.ru/cgi/xapi_meta?node[%@][bbox=%@]", searchString,boundingBox)
        #endif
        
        Alamofire.request(
            .GET,
            //            "http://overpass.osm.rambler.ru/cgi/xapi_meta?node[highway=rest_area][bbox=6.3584695643,49.1130992988,7.4034901078,49.6393467247]",
            //                "http://overpass.osm.rambler.ru/cgi/xapi_meta?node[highway=emergency_access_point][bbox=6.8997573853,49.2041400138,7.0501327515,49.2993821679]",
            //            "http://overpass.osm.rambler.ru/cgi/xapi_meta?node[highway=speed_camera][bbox=6.8997573853,49.2041400138,7.0501327515,49.2993821679]",
            
            
            //        > Saarland:
            //        > 49.6393467247 6.3584695643 49.1130992988 7.4034901078
            // Achtung: Werte vertauscht!!
            urlString,
            //            "http://overpass.osm.rambler.ru/cgi/xapi_meta?node[tourism=viewpoint][bbox=6.3584695643,49.1130992988,7.4034901078,49.6393467247]",
            encoding: .URL)
            .validate()
            .responseString { response in
                print("Success: \(response.result.isSuccess)")
                print("Response String: \(response.result.value)")
                let message : String
                var isRealRequest :Bool
                    isRealRequest = response.response?.allHeaderFields != nil
                
                if (isRealRequest)
                    {
                    if let httpError = response.result.error
                    {
                        let statusCode = httpError.code
                    }
                    else
                    { //no errors
                        let statusCode = (response.response?.statusCode)!
                    }
                    
                    if let httpStatusCode = response.response?.statusCode
                    {
                        switch(httpStatusCode)
                        {
                        case 504:
                            message = "Gateway Time-out"
                        case 200:
                            message = ""
                        default:
                            message = "Ok"
                        }
                    }
                    else
                    {
                        message = "default"
                    }
                    if (message.characters.count > 0)
                    {
                        self.showAlert(message)
                    }
                }
            }
            .responseObject { (response: Result< Osm, NSError>) in
                print("Response Object: ")
                
                
                if (response.isFailure)
                {
                    print ("Response: \(response.error)")
                }
                else
                {
                    if let result = response.value
                    {
                        var zoomRect :MKMapRect = MKMapRectNull
                        
                        for node in result.node
                        {
                            print(node._lat)
                            let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(node._lat!), longitude: Double(node._lon!))
                            
                            node.type = searchString
                            
                            let anotation = NodeAnnotationView.init(title: node.title(), coordinate: location, node: node)
                            
                            self.mapView .addAnnotation(anotation)
                            
                            let annotationPoint : MKMapPoint = MKMapPointForCoordinate(location);
                            let pointRect:MKMapRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
                            if (MKMapRectIsNull(zoomRect))
                            {
                                zoomRect = pointRect;
                            }
                            else
                            {
                                zoomRect = MKMapRectUnion(zoomRect, pointRect);
                            }
                        }
                        self.mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsetsMake(10,10,10,10), animated: true)
                        self.title = String(format:"%d", self.mapView.annotations.count)
                        
                        for object in self.mapView.annotationsInMapRect(self.mapView.visibleMapRect)
                        {
                            if (object .conformsToProtocol(MKAnnotation))
                            {
                                self.mapView.selectAnnotation(object as! MKAnnotation, animated: false)
                            }
                        }
                    }
                }
        }
    }
    
    
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
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            print("Disclosure Pressed! \( view.annotation!.subtitle)")
        }
        
    }
    
    
//    You should be careful with number of simultaneously tracking regions. The system limited regions count to 20 for one app. If you want to work with larger regions count you can track only this regions, which are close to user’s location right now. When the user’s location changes, you can remove regions that are now farther way and add regions coming up on the user’s path. If reach regions limit, location manager will fire monitoringDidFailForRegion method. You can handle it for better app’s UX.
    func setupData() {
        // 1. check if system can monitor regions
        if CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion.self) {
            
            // 2. region data
            let title = "Apple "
            let coordinate = CLLocationCoordinate2DMake(37.331002, -122.029663)
            let regionRadius = 300.0
            
            // 3. setup region
            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude,
                longitude: coordinate.longitude), radius: regionRadius, identifier: title)
            locationManager.startMonitoringForRegion(region)
            
            // 4. setup annotation
            let restaurantAnnotation = MKPointAnnotation()
            restaurantAnnotation.coordinate = coordinate;
            restaurantAnnotation.title = "\(title)";
            mapView.addAnnotation(restaurantAnnotation)
            
            // 5. setup circle
            let circle = MKCircle(centerCoordinate: coordinate, radius: regionRadius)
            mapView.addOverlay(circle)
        }
        else {
            print("System can't track regions")
        }
    }
    
    // 6. draw circle
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = UIColor.redColor()
        circleRenderer.lineWidth = 1.0
        return circleRenderer
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
                let reuseId = "peak"
                var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
                if (anView == nil)
                {
                    anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                    anView!.canShowCallout = true
                    anView!.image = UIImage(named: "mountain-512")
                    
//                    let label:UILabel = UILabel.init(frame: CGRectMake(0, 0, 20, 20))
//                    label.text = "🔼"
//                    anView?.addSubview(label)
                }
                return anView
            }
        }
        
        return nil
        
////            anView!.image = UIImage(named:"Icon-76")

    }
       
    
    // MARK: LocationManager
    // 1. user enter region
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        showAlert("enter \(region.identifier)")
    }

    // 2. user exit region
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        showAlert("exit \(region.identifier)")
    }

    
//    // CLLocationManagerDelegate
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location = locations.last
////        let haccuracy = location?.horizontalAccuracy
////        let vaccuracy = location?.verticalAccuracy
////        
////        print(haccuracy)
////        print(vaccuracy)
//        
//        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//        
//        self.mapView.setRegion(region, animated: true)
//        
//        manager.stopUpdatingLocation()
//    }

    
    // MARK: Helper
    func showAlert(message: NSString)
    {
        // WARNING: Mögliche doppelte alerts
            let alert = UIAlertController(title: "Alert",
                                      message: message as String,
                                      preferredStyle: UIAlertControllerStyle.Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            
        }
        alert.addAction(OKAction)
        
        presentViewController(alert, animated: true, completion:nil)
    }
    
//    func fetchAllRooms(completion: ([Node]?) -> Void) {
//    func fetchAllRooms(completionHandler: (NSDictionary?,NSError?)) -> () {
//        Alamofire.request(
//            .GET,
//            "http://overpass.osm.rambler.ru/cgi/xapi_meta?node[highway=rest_area][bbox=6.3584695643,49.1130992988,7.4034901078,49.6393467247]",
//            encoding: .URL)
//            .validate()
//            .responseString { response in
//                print("Response String: \(response.result.value)")
//            }
//            .responseJSON { response in
//                print(response.request)  // original URL request
//                print(response.response) // URL response
//                print(response.data)     // server data
//                print(response.result)   // result of response serialization
//                
//                if let JSON = response.result.value {
//                    print("JSON: \(JSON)")
//                }
//            }
//            .response { (request, response, data, error) in
//                print(request)
//                print(response)
//                print(error)
//                
//                var xml = SWXMLHash.parse(data!)
////                var nodes: [Node] = try xml["osm"]["node"].value()
//                
//                print(xml["osm"].element?.text)
//                print(xml["osm"]["node"][1].element?.attributes["id"])
//                
////                func enumerate(indexer: XMLIndexer) {
////                    for child in indexer.children {
////                        NSLog(child.element!.name)
////                        enumerate(child)
////                    }
////                }
//                
//             
////                var rooms = [RemoteRoom]()
//                //                for roomDict in rows {
//                //                    rooms.append(RemoteRoom(jsonData: roomDict))
//                //                }
//                //
//                
//                
////                enumerate(xml)
//                completionHandler(xml,nil)
//            }
    
//            .responseJSON { (response) -> Void in
//                guard response.result.isSuccess else {
//                    print("Error while fetching remote rooms: \(response.result.error)")
//                    completion(nil)
//                    return
//                }
//                
//                guard let value = response.result.value as? [String: AnyObject],
//                    rows = value["rows"] as? [[String: AnyObject]] else {
//                        print("Malformed data received from fetchAllRooms service")
//                        completion(nil)
//                        return
//                }
//                
//                var rooms = [RemoteRoom]()
//                for roomDict in rows {
//                    rooms.append(RemoteRoom(jsonData: roomDict))
//                }
//                
//                completion(rooms)
//        }
//    }
}

