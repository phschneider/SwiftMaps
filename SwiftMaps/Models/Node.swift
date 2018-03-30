//
//  Node.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 09.07.16.
//  Copyright © 2016 phschneider.net. All rights reserved.
//

import Foundation
import EVReflection
import CoreData

class Node: EVObject{
    var _version: String?
    var _uid: String?
    
    var _user: String?
    var _id: String?
    var _changeset: String?
    var _timestamp: String?
    
    var _lat: NSNumber?
    var _lon: NSNumber?
    var tag: [Tag] = [Tag]()

    var _ref: String?
    
    var type: String?

    func toCoreData()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataNode")
        let predicateID = NSPredicate(format: "id == %@",_id!)
        fetchRequest.predicate = predicateID

        do {

            let results = try appDelegate.managedObjectContext.fetch(fetchRequest)
            if results.count > 0 {
                    
            }else {
                var coreDataNode:NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: "CoreDataNode", into: appDelegate.managedObjectContext)
                coreDataNode.setValue(self.type, forKey: "type")
                coreDataNode.setValue(self._ref, forKey: "ref")
//        coreDataNode.setValue(self.tag, forKey: "tag")
                coreDataNode.setValue(Int64(self._id!), forKey: "id")
                coreDataNode.setValue(self._lat, forKey: "lat")
                coreDataNode.setValue(self._lon, forKey: "lon")
            }
        }
        catch let error {
            print(error.localizedDescription)
        }
    }

    func isPeak() -> Bool
    {
        return (self.type?.lowercased().range(of: "peak") != nil)
    }
    
    func isToilet() -> Bool
    {
        return (self.type?.lowercased().range(of: "toilets") != nil)
    }
    
    func isSpeedCam() -> Bool
    {
        return (self.type?.lowercased().range(of: "speed_camera") != nil)
    }
    
    func isAtm() -> Bool
    {
        return (self.type?.lowercased().range(of: "amenity=atm") != nil)
    }
    
    func isBank() -> Bool
    {
        return (self.type?.lowercased().range(of: "amenity=bank") != nil)
    }
    
    func isBench() -> Bool
    {
        return (self.type?.lowercased().range(of: "amenity=bench") != nil)
    }
    
    func isFuel() -> Bool
    {
        return (self.type?.lowercased().range(of: "amenity=fuel") != nil)
    }
    
    func isCafe() -> Bool
    {
        return (self.type?.lowercased().range(of: "amenity=cafe") != nil)
    }
    
    func isShelter() -> Bool
    {
        return (self.type?.lowercased().range(of: "amenity=shelter") != nil)
    }
    
    func isBakery() -> Bool
    {
        return (self.type?.lowercased().range(of: "shop=bakery") != nil)
    }
    
    func isIceCream() -> Bool
    {
        return (self.type?.lowercased().range(of: "cuisine=ice_cream") != nil)
    }
    
    func isPicnic() -> Bool
    {
        return (self.type?.lowercased().range(of: "tourism=picnic_site") != nil)
    }
    
    func isViewpoint() -> Bool
    {
        return (self.type?.lowercased().range(of: "tourism=viewpoint") != nil)
    }
    
    func isFastFood() -> Bool
    {
        return (self.type?.lowercased().range(of: "amenity=fast_food") != nil)
    }
    
    func isRestaurant() -> Bool
    {
        return (self.type?.lowercased().range(of: "amenity=restaurant") != nil)
    }
    
    func isSupermarket() -> Bool
    {
        return (self.type?.lowercased().range(of: "shop=supermarket") != nil)
    }
    
    func isEmergencyAccessPoint() -> Bool
    {
        return (self.type?.lowercased().range(of: "highway=emergency_access_point") != nil)
    }
    
    func isFountain() -> Bool
    {
        return (self.type?.lowercased().range(of: "amenity=fountain") != nil)
    }
    
    
    
    
    func title() -> String
    {
        var title:String = ""
        let name:Tag? = (self.tagForKey("name"))
        let ele:Tag? = (self.tagForKey("ele"))
        let description:Tag? = (self.tagForKey("description"))

        if (self.isEmergencyAccessPoint() && _ref != nil)
        {
            title = _ref!
        }

        if (name != nil)
        {
            title = title + (name?._v)!
        }

        // Peak ...
        if (ele != nil)
        {
            title = title + " (" + (ele?._v)! + ")"
        }

        if (description != nil)
        {
            title = title + " (" + (description?._v)! + ")"
        }


        if (title.characters.count == 0)
        {
            title = self._id!
        }

        return title
    }
    
    func tagForKey(_ key:String) -> Tag? {
        for object in tag {
            if (object._k == key)
            {
                return object
            }
        }
        return nil
    }
}
