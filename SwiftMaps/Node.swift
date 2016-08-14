//
//  Node.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 09.07.16.
//  Copyright © 2016 phschneider.net. All rights reserved.
//

import Foundation
import EVReflection

class Node: EVObject {
//    let title: String
//    let price: Double
//    let id: Int
    var _version: String?
    var _uid: String?
    
    var _user: String?
    var _id: String?
    var _changeset: String?
    var _timestamp: String?
    
    var _lat: NSNumber?
    var _lon: NSNumber?
    var tag: [Tag] = [Tag]()


    
//    static func deserialize(node: XMLIndexer) throws -> Node {
//        return try Node(
//            lat: (node.element?.attributes["lat"])!
////            id: attributes["id"],
////            lat: node?attributes["lat"],
////            lon: node?attributes["lon"]
////            
////            price: node["lon"].value(),
////            year: node["year"].value(),
////            amount: node["amount"].value()
//        )
//    }
}
