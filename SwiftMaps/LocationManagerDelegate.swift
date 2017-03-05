//
//  LocationManagerDelegate.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 20.11.16.
//  Copyright © 2016 phschneider.net. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    
    
    // MARK: LocationManager
    // 1. user enter region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        AlertController().showAlert("enter \(region.identifier)")
    }
    
    // 2. user exit region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        AlertController().showAlert("exit \(region.identifier)")
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
          
}
