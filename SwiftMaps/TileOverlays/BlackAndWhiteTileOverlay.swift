//
//  BlackAndWhiteTileOverlay.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 08.11.17.
//  Copyright © 2017 phschneider.net. All rights reserved.
//

import Foundation

class BlackAndWhiteTileOverlay: TileOverlay {
    convenience init() {
        self.init(urlTemplate:"http://a.tile.stamen.com/toner/{z}/{x}/{y}.png")
    }
    
    override init(urlTemplate URLTemplate: String?) {
        super.init(urlTemplate: URLTemplate)
        self.canReplaceMapContent = false;
    }
    
    override func name () -> String
    {
        return "black-and-white"
    }
}
