//
//  MapBoxRunBikeHikeTileOverlay.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 05.04.17.
//  Copyright © 2017 phschneider.net. All rights reserved.
//

import Foundation
import MapKit

class MapBoxRunBikeHikeTileOverlay: TileOverlay {
    convenience init() {
        self.init(urlTemplate:"https://api.mapbox.com/v4/mapbox.run-bike-hike/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoicGhzY2huZWlkZXIiLCJhIjoiajRrY3hyUSJ9.iUqFM9KNijSRZoI-cHkyLw")
    }
    
    override init(urlTemplate URLTemplate: String?) {
        super.init(urlTemplate: URLTemplate)
        self.canReplaceMapContent = true;
    }
    
    override func name () -> String
    {
        return "mapbox-runbikehike"
    }
}
