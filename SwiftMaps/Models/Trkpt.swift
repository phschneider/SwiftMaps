//
//  Trkpt.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 06.04.17.
//  Copyright © 2017 phschneider.net. All rights reserved.
//

import Foundation
import EVReflection

class Trkpt: EVObject {
    var ele: String?
    var time: String?
    
    var _lat: NSNumber?
    var _lon: NSNumber?
}
