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
    var _version: String?
    var _uid: String?
    
    var _user: String?
    var _id: String?
    var _changeset: String?
    var _timestamp: String?
    
    var _lat: NSNumber?
    var _lon: NSNumber?
    var tag: [Tag] = [Tag]()

    var type: String?
    
    func isPeak() -> Bool
    {
        return (self.type?.lowercaseString.rangeOfString("peak") != nil)
    }
    
    func isToilet() -> Bool
    {
        return (self.type?.lowercaseString.rangeOfString("toilets") != nil)
    }
    
    func isSpeedCam() -> Bool
    {
        return (self.type?.lowercaseString.rangeOfString("speed_camera") != nil)
    }
    
    func title() -> String
    {
        var title:String = ""
        let name:Tag? = (self.tagForKey("name"))
        let ele:Tag? = (self.tagForKey("ele"))
        
        if (name != nil)
        {
            title = title + (name?._v)!
        }
        if (ele != nil)
        {
            title = title + " (" + (ele?._v)! + ")"
        }
        
        if (title.characters.count == 0)
        {
            title = self._id!
        }
        
        return title
    }
    
    func tagForKey(key:String) -> Tag? {
        for object in tag {
            if (object._k == key)
            {
                return object
            }
        }
        return nil
    }
}
