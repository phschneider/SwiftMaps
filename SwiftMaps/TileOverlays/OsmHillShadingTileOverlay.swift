//
//  OsmHillShadingTileOverlay.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 07.11.17.
//  Copyright © 2017 phschneider.net. All rights reserved.
//

import Foundation

class OsmHillShadingTileOverlay: TileOverlay {
    convenience init() {
        self.init(urlTemplate:"http://c.tiles.wmflabs.org/hillshading/{z}/{x}/{y}.png")
    }
    
    override init(urlTemplate URLTemplate: String?) {
        super.init(urlTemplate: URLTemplate)
        self.canReplaceMapContent = false;
    }
    
    override func name () -> String
    {
        return "osm-hill-shading"
    }
}

