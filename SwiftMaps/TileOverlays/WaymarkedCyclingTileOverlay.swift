//
//  WaymarkedCyclingTileOverlay.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 06.11.17.
//  Copyright © 2017 phschneider.net. All rights reserved.
//

import Foundation

class WaymarkedCyclingTileOverlay: TileOverlay {
    convenience init() {
        self.init(urlTemplate:"https://tile.waymarkedtrails.org/cycling/{z}/{x}/{y}.png")
    }
    
    override init(urlTemplate URLTemplate: String?) {
        super.init(urlTemplate: URLTemplate)
        self.canReplaceMapContent = false;
    }
    
    override func name () -> String
    {
        return "waymarked-cycling"
    }
}
