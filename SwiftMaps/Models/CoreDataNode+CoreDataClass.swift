//
//  CoreDataNode+CoreDataClass.swift
//  
//
//  Created by Philip Schneider on 29.03.18.
//
//

import Foundation
import CoreData

@objc(CoreDataNode)
public class CoreDataNode: NSManagedObject {

    func toNode() -> Node
    {
        var node:Node = Node()
        node._id = String(format:"%lu", self.id!.int64Value)
        node._ref = self.ref
        node._lat = self.lat
        node._lon = self.lon
        node.type = self.type

        return node
    }
}
