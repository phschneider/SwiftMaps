//
//  Api.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 20.11.16.
//  Copyright © 2016 phschneider.net. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

import Alamofire
//import SWXMLHash
import AlamofireXmlToObjects
import CoreData


class Api {
    func requestForBoundingBox(_ searchString: String, boundingBox: NSString ,mapView: MKMapView)
    {
        self.requestForBoundingBox(searchString, boundingBox: boundingBox, mapView: mapView, gpxTrack: nil)
    }

    func requestForCurrentMapRect(_ searchString: String, mapView: MKMapView, gpxTrack:Gpx?)
    {
        let bounding:[Double] = mapView.getBoundingBox(mapView.visibleMapRect)
        let boundingBoxString:String = String(format: "%.3f,%.3f,%.3f,%.3f", bounding[1],bounding[0],bounding[3],bounding[2])

        self.requestForBoundingBox(searchString, boundingBox: boundingBoxString as NSString, mapView: mapView, gpxTrack: gpxTrack)
    }

    func requestForMapRect(_ searchString: String, mapRect: MKMapRect , mapView: MKMapView, gpxTrack:Gpx?)
    {
        let bounding:[Double] = mapView.getBoundingBox(mapRect)
        let boundingBoxString:String = String(format: "%.3f,%.3f,%.3f,%.3f", bounding[1],bounding[0],bounding[3],bounding[2])

        self.requestForBoundingBox(searchString, boundingBox: boundingBoxString as NSString, mapView: mapView, gpxTrack: gpxTrack)
    }

    func requestForBoundingBox(_ searchString: String, boundingBox: NSString , mapView: MKMapView, gpxTrack:Gpx?)
    {
        self.requestForBoundingBox(searchString, boundingBox: boundingBox, mapView: mapView, gpxTrack:gpxTrack, distance: 0.0)

    }

    func requestForBoundingBox(_ searchString: String, boundingBox: NSString , mapView: MKMapView, gpxTrack:Gpx?, distance: Double)
    {
        
        var urlString : String = ""
        let serverString = "http://overpass-api.de/api"
        //http://overpass-api.de/api/
        
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let url = URL(fileURLWithPath: path)
            let filePath = url.appendingPathComponent("sample.xml").path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                print("FILE AVAILABLE %@",filePath)
                urlString = String(format:"file://%@",filePath)
            } else {
                print("FILE NOT AVAILABLE")
            }
        #endif
        
        if (urlString.isEmpty)
        {
            urlString = String(format:"%@/xapi_meta?%@[bbox=%@]", serverString, searchString, boundingBox)            
        }
        
        print("Search String: \(searchString)")
        print("Url String: \(urlString)")
        
        Alamofire.request(
            //            "http://overpass.osm.rambler.ru/cgi/xapi_meta?node[highway=rest_area][bbox=6.3584695643,49.1130992988,7.4034901078,49.6393467247]",
            //                "http://overpass.osm.rambler.ru/cgi/xapi_meta?node[highway=emergency_access_point][bbox=6.8997573853,49.2041400138,7.0501327515,49.2993821679]",
            //            "http://overpass.osm.rambler.ru/cgi/xapi_meta?node[highway=speed_camera][bbox=6.8997573853,49.2041400138,7.0501327515,49.2993821679]",
            
            
            //        > Saarland:
            //        > 49.6393467247 6.3584695643 49.1130992988 7.4034901078
            // Achtung: Werte vertauscht!!
            urlString
            //            "http://overpass.osm.rambler.ru/cgi/xapi_meta?node[tourism=viewpoint][bbox=6.3584695643,49.1130992988,7.4034901078,49.6393467247]",
            )
            .validate()
            .responseString { response in

                // FEHLERBEHANDLUNG ...
                print("Success: \(response.result.isSuccess)")
                print("Response String: \(response.result.value)")
                let message : String
                var isRealRequest :Bool
                isRealRequest = response.response?.allHeaderFields != nil
                
                if (isRealRequest)
                {
                    if let httpError = response.result.error
                    {
                        let statusCode = httpError._code
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
                        AlertController().showAlert(message)
                    }
                }
            }
            .responseObject { (response: DataResponse<Osm>) in

                // PARSING ....
                print("Response Object: ")
                
                
                if (response.result.isFailure)
                {
                    print ("Response: \(response.error)")
                }
                else
                {
                    if let result = response.value
                    {
                        var zoomRect :MKMapRect = MKMapRectNull
                        var annotations: [MKAnnotation] = []

                        if (result.way.count == 0)
                        {
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            for node in result.node
                            {
//                                print(node._lat)
                                let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(node._lat!), longitude: Double(node._lon!))
                                let loc = CLLocation.init(latitude: node._lat as! CLLocationDegrees, longitude: node._lon as! CLLocationDegrees)
                                
                                // Distance Filter => wir zeigen einen GPX-Track an
                                if (gpxTrack != nil && distance != 0.0 && (gpxTrack?.smallesDistance(current: loc).isLess(than: distance))!)
                                {
                                    node.type = searchString
                                    
                                    let annotation = NodeAnnotationView.init(title: node.title(), coordinate: location, node: node)
                                    
                                    annotations.append(annotation)
                                    
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
                                else if (gpxTrack == nil || distance == 0.0)
                                {
                                    node.type = searchString

                                    let annotation = NodeAnnotationView.init(title: node.title(), coordinate: location, node: node)

                                    annotations.append(annotation)

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
                                node.toCoreData()
                            }

                            do {
                                try appDelegate.managedObjectContext.save()
                            } catch {
                                fatalError("Failure to save api context: \(error)")
                            }
                        }
                        
                        for way in result.way
                        {
                            var coordinates:[CLLocationCoordinate2D] = []
                            for nd in way.nd
                            {
                                var wayNode:Node = result.node.first(where: { $0._id! == nd._ref! })!
                                print(wayNode)
                                coordinates.append(CLLocationCoordinate2D(latitude: Double(wayNode._lat!), longitude: Double(wayNode._lon!)))
                            }
                            
                            let polygon = MKPolygon(coordinates: &coordinates, count: coordinates.count)
                            mapView.add(polygon)
                        }
                        
                        
                        if (annotations.count > 0)
                        {
                            mapView.addAnnotations(annotations)
                            mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsetsMake(10,10,10,10), animated: true)
                        }
                    }
                }
        }
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
