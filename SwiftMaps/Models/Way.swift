//
//  Way.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 05.03.17.
//  Copyright © 2017 phschneider.net. All rights reserved.
//

import Foundation
import EVReflection

class Way: EVObject {
    var _version: String?
    var _uid: String?
    
    var _user: String?
    var _id: String?
    var _changeset: String?
    var _timestamp: String?
    
    var _lat: NSNumber?
    var _lon: NSNumber?
    var tag: [Tag] = [Tag]()
    
    var nd: [Node] = [Node]()
    
    var type: String?
    
}
