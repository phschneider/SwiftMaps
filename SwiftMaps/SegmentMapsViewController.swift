//
//  SegmentMapsViewController.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 04.03.17.
//  Copyright © 2017 phschneider.net. All rights reserved.
//

import Foundation
import StravaKit
import MapKit
import SafariServices


class SegmentMapsViewController: MapViewController {
    
    var safariViewController: SFSafariViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Strava.isDebugging = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(SegmentMapsViewController.stravaAuthorizationCompleted(_:)), name: NSNotification.Name(rawValue: StravaAuthorizationCompletedNotification), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: StravaAuthorizationCompletedNotification), object: nil)
    }
    
    internal func stravaAuthorizationCompleted(_ notification: Notification?) {
        assert(Thread.isMainThread, "Main Thread is required")
        safariViewController?.dismiss(animated: true, completion: nil)
        safariViewController = nil
        
        guard let userInfo = notification?.userInfo,
            let status = userInfo[StravaStatusKey] as? String else {
                return
        }
        if status == StravaStatusSuccessValue {

        }
        else if let error = userInfo[StravaErrorKey] as? NSError {
            debugPrint("Error: \(error.localizedDescription)")
        }
    }

    func authorize()
    {
        self.mapView .removeAnnotations(self.mapView.annotations)
        
        let redirectURI = "segments://localhost/oauth/signin"
        Strava.set(clientId: "16521", clientSecret: "adee70512a0a69bbbd53c1376ee1e3ca49464c15", redirectURI: redirectURI)
        
        if let URL = Strava.userLogin(scope: .Public) {
            let vc = SFSafariViewController(url: URL, entersReaderIfAvailable: false)
            present(vc, animated: true, completion: nil)
            safariViewController = vc
        }
    }
    
    override func addTapped(){
//        self.authorize()
        self.loadSegments()
            }
    
    func loadSegment()
    {
        Strava.getSegment(13195769) { (segment, error) in
            if let _ = segment {
                
                
                self.mapView.add( MKPolyline.init(coordinates: (segment?.coordinates)!, count: (segment?.coordinates?.count)!) )
            }
            else if let error = error {
                
            }
        }
    }
    
    func loadSegments(){
        let bottomLeft:CLLocationCoordinate2D = self.mapView.getSWCoordinate(self.mapView.visibleMapRect)
        let topRight:CLLocationCoordinate2D = self.mapView.getNECoordinate(self.mapView.visibleMapRect)
        
        let latitude1: CLLocationDegrees = bottomLeft.latitude
        let longitude1: CLLocationDegrees = bottomLeft.longitude
        let latitude2: CLLocationDegrees = topRight.latitude
        let longitude2: CLLocationDegrees = topRight.longitude
        let coordinate1 = CLLocationCoordinate2DMake(latitude1, longitude1)
        let coordinate2 = CLLocationCoordinate2DMake(latitude2, longitude2)
        
        guard let mapBounds = MapBounds(coordinate1: coordinate1, coordinate2: coordinate2) else {
            let error = NSError(domain: "Testing", code: 1, userInfo: nil)
            //            completionHandler(false, error)
            return
        }
        
        Strava.getSegments(mapBounds) { (segments, error) in
            if let _ = segments {
                //completionHandler(true, nil)
                print (segments)
                for segment in  segments as! [Segment]! {
                    print(segment)
                    if (segment.coordinates != nil)
                    {
                        self.mapView.add( MKPolyline.init(coordinates: segment.coordinates!, count: (segment.coordinates?.count)!) )
                    }
                }
                

            }
            else if let error = error {
                //completionHandler(false, error)
            }
        }

    }
}
