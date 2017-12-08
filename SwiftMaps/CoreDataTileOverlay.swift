//
//  CoreDataTileOverlay.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 25.11.17.
//  Copyright © 2017 phschneider.net. All rights reserved.
//

import Foundation

class CoreDataTileOverlay: TileOverlay {
    var tileName:String = ""

//    convenience init() {
//        let array = ["a", "b", "c"]
//        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
//        self.init(urlTemplate: (tileUseHttps==false) ? "http://" : "https://" + array[randomIndex] + "." + tileUrl + "/{z}/{x}/{y}.png")
//    }
    
//    override init(urlTemplate URLTemplate: String?) {
//        super.init(urlTemplate: URLTemplate)
//        self.canReplaceMapContent = false;
//    }
    
    override func name () -> String
    {
        return tileName
    }
}
