//
//  KomootTileOverlay.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 04.08.17.
//  Copyright © 2017 phschneider.net. All rights reserved.
//

import Foundation
import MapKit

class KomootTileOverlay: TileOverlay {
    convenience init() {
        let array = ["a", "b", "c"]
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))        
        self.init(urlTemplate:"https://" + array[randomIndex] + ".tile.hosted.thunderforest.com/komoot-2/{z}/{x}/{y}.png")
    }
    
    override init(urlTemplate URLTemplate: String?) {
        super.init(urlTemplate: URLTemplate)
        self.canReplaceMapContent = false;
    }
    
    override func name () -> String
    {
        return "komoot"
    }
}

