//
//  MapBoxCustomTileOverlay.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 09.11.17.
//  Copyright © 2017 phschneider.net. All rights reserved.
//

import Foundation

class MapBoxCustomTileOverlay: TileOverlay {
    convenience init() {
        self.init(urlTemplate:"https://api.mapbox.com/v4/phschneider.842a0982/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoicGhzY2huZWlkZXIiLCJhIjoiajRrY3hyUSJ9.iUqFM9KNijSRZoI-cHkyLw")
    }
    
    override init(urlTemplate URLTemplate: String?) {
        super.init(urlTemplate: URLTemplate)
        self.canReplaceMapContent = true;
    }
    
    // Run, Bike, and Hike
    override func name () -> String
    {
        return "mapbox-phschneider.842a0982"
    }
}
