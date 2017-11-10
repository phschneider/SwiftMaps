//
//  OpenTopoMapTileOverlay.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 10.11.17.
//  Copyright © 2017 phschneider.net. All rights reserved.
//

import Foundation

class OpenTopoMapTileOverlay: TileOverlay {
    convenience init() {
        let array = ["a", "b", "c"]
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
        self.init(urlTemplate:"https://" + array[randomIndex] + ".tile.opentopomap.org/{z}/{x}/{y}.png")
    }
    
    override init(urlTemplate URLTemplate: String?) {
        super.init(urlTemplate: URLTemplate)
        self.canReplaceMapContent = false;
    }
    
    override func name () -> String
    {
        return "open-topo-map"
    }
}
