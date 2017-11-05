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
        // https://heatmap-external-a.strava.com/tiles/ride/hot/13/4254/2805@2x.png?v=19
        // https://heatmap-external-b.strava.com/tiles/ride/hot/13/4256/2804@2x.png?v=19
        // self.init(urlTemplate:"http://globalheat.strava.com/tiles/cycling/color1/{z}/{x}/{y}.png")
        // self.init(urlTemplate:"http://globalheat.strava.com/tiles/cycling/color2/{z}/{x}/{y}.png")
        // self.init(urlTemplate:"http://globalheat.strava.com/tiles/cycling/color3/{z}/{x}/{y}.png")
        // self.init(urlTemplate:"http://globalheat.strava.com/tiles/cycling/color4/{z}/{x}/{y}.png") // HELLBLAU
        // self.init(urlTemplate:"http://globalheat.strava.com/tiles/cycling/color5/{z}/{x}/{y}.png") // ROT
        // self.init(urlTemplate:"http://globalheat.strava.com/tiles/cycling/color6/{z}/{x}/{y}.png") // Hellblau
        // self.init(urlTemplate:"http://globalheat.strava.com/tiles/cycling/color7/{z}/{x}/{y}.png") // MarinBlau
        self.init(urlTemplate:"http://globalheat.strava.com/tiles/cycling/color8/{z}/{x}/{y}.png") // Orange
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
