//
//  MapViewExtension.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 20.11.16.
//  Copyright © 2016 phschneider.net. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
 
    // MARK: Bounding Box
    // http://www.softwarepassion.com/how-to-get-geographic-coordinates-of-the-visible-mkmapview-area-in-ios/
    func getCoordinateFromMapRectanglePoint(_ x:Double, y:Double) -> CLLocationCoordinate2D
    {
        return MKCoordinateForMapPoint(MKMapPointMake(x, y))
    }
    
    func getNECoordinate(_ mapRect: MKMapRect) -> CLLocationCoordinate2D
    {
        return self.getCoordinateFromMapRectanglePoint(MKMapRectGetMaxX(mapRect),y:mapRect.origin.y);
    }
    
    func getNWCoordinate(_ mapRect: MKMapRect) -> CLLocationCoordinate2D
    {
        return self.getCoordinateFromMapRectanglePoint(MKMapRectGetMinX(mapRect),y:mapRect.origin.y);
    }
    
    func getSECoordinate(_ mapRect: MKMapRect) -> CLLocationCoordinate2D
    {
        return self.getCoordinateFromMapRectanglePoint(MKMapRectGetMaxX(mapRect),y:MKMapRectGetMaxY(mapRect));
    }
    
    func getSWCoordinate(_ mapRect: MKMapRect) -> CLLocationCoordinate2D
    {
        return self.getCoordinateFromMapRectanglePoint(mapRect.origin.x,y:MKMapRectGetMaxY(mapRect));
    }
    
    func getBoundingBox(_ mapRect: MKMapRect) -> [Double]
    {
        let bottomLeft:CLLocationCoordinate2D = self.getSWCoordinate(mapRect)
        let topRight:CLLocationCoordinate2D = self.getNECoordinate(mapRect)
        
        return [bottomLeft.latitude, bottomLeft.longitude, topRight.latitude, topRight.longitude]
    }
}
