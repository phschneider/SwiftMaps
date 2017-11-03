//
//  NodeAnnotationView.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 14.08.16.
//  Copyright © 2016 phschneider.net. All rights reserved.
//

import Foundation
import MapKit

class NodeAnnotationView: NSObject, MKAnnotation  {
    var node: Node!
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D, node:Node) {
        self.title = title
        self.coordinate = coordinate
        self.node = node
        
        
        super.init()
    }
}
