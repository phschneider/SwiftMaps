//
//  StravaTileOverlay.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 05.04.17.
//  Copyright © 2017 phschneider.net. All rights reserved.
//

import Foundation
import MapKit

class StravaTileOverlay: TileOverlay {
    convenience init() {
        self.init(urlTemplate:"http://globalheat.strava.com/tiles/cycling/color1/{z}/{x}/{y}.png")
    }
    
    override init(urlTemplate URLTemplate: String?) {
        super.init(urlTemplate: URLTemplate)
        self.canReplaceMapContent = false;
    }
    
    override func name () -> String
    {
        return "strava"
    }
}
