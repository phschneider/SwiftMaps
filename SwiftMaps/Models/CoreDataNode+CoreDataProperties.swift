//
//  CoreDataNode+CoreDataProperties.swift
//  
//
//  Created by Philip Schneider on 31.03.18.
//
//

import Foundation
import CoreData


extension CoreDataNode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataNode> {
        return NSFetchRequest<CoreDataNode>(entityName: "CoreDataNode")
    }

    @NSManaged public var id: NSNumber?
    @NSManaged public var lat: NSNumber?
    @NSManaged public var lon: NSNumber?
    @NSManaged public var type: String?
    @NSManaged public var ref: String?
    @NSManaged public var tags: NSSet?
    @NSManaged public var ways: NSSet?

}

// MARK: Generated accessors for tags
extension CoreDataNode {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: CoreDataTag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: CoreDataTag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}

// MARK: Generated accessors for ways
extension CoreDataNode {

    @objc(addWaysObject:)
    @NSManaged public func addToWays(_ value: CoreDataWay)

    @objc(removeWaysObject:)
    @NSManaged public func removeFromWays(_ value: CoreDataWay)

    @objc(addWays:)
    @NSManaged public func addToWays(_ values: NSSet)

    @objc(removeWays:)
    @NSManaged public func removeFromWays(_ values: NSSet)

}
