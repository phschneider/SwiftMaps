//
//  MapBoxCustomPathTileOverlay.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 09.11.17.
//  Copyright © 2017 phschneider.net. All rights reserved.
//

import Foundation

class MapBoxCustomPathTileOverlay: TileOverlay {
    convenience init() {
        self.init(urlTemplate:"https://api.mapbox.com/v4/phschneider-style-two.e41d7c02/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoicGhzY2huZWlkZXItc3R5bGUtdHdvIiwiYSI6ImNpaDM3MDNxMTAwcGtycGx5Z28xZWswZnUifQ.V-02MFf9uVKeWewmI06X5A")
    }
    
    override init(urlTemplate URLTemplate: String?) {
        super.init(urlTemplate: URLTemplate)
        self.canReplaceMapContent = true;
    }
    
    // Run, Bike, and Hike
    override func name () -> String
    {
        return "mapbox-phschneider-style-two.e41d7c02"
    }
}
