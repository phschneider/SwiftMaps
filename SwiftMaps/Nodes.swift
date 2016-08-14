//
//  Nodes.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 12.07.16.
//  Copyright © 2016 phschneider.net. All rights reserved.
//

import Foundation
import EVReflection

class Osm: EVObject {
    var node: [Node] = [Node]()
    
    var __name: String?
    
    var _version: String?
    var _generator: String?
    
    var meta: String?
    var note: String?
}