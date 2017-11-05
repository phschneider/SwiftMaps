//
//  Wpt.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 06.04.17.
//  Copyright © 2017 phschneider.net. All rights reserved.
//

import Foundation
import EVReflection

class Wpt: EVObject {
    var ele: String?
    var name: String?
    var desc: String?
    var sym: String?
    var type: String?
    
    var _lat: NSNumber?
    var _lon: NSNumber?
}
