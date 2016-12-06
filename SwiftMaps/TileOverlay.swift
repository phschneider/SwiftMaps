//
//  TileOverlay.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 02.12.16.
//  Copyright © 2016 phschneider.net. All rights reserved.
//

import Foundation
import MapKit

class TileOverlay: MKTileOverlay {

    let cache: NSCache = NSCache()
    
    override init(URLTemplate: String?) {
        super.init(URLTemplate: URLTemplate)
    }
    
    func name () -> String
    {
        return "default"
    }
    
    func mainFolder () -> NSString
    {
//        let docsDir:String = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0].absoluteString
//        let databasePath = docsDir.stringByAppendingFormat("tiles/%@", self.name())
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let databasePath =  dirPaths[0].stringByAppendingFormat("/tiles/%@", self.name())
        return databasePath;
    }
    
    func storageForPath(path: MKTileOverlayPath) -> String
    {
        return self.storageForComponents(path.z, x: path.x, y: path.y)
    }
    
    func storageForComponents(z: Int, x: Int, y:Int) -> String
    {
//        let directory = String.init(format: "%ld/%ld/%ld.png",z,x,y)
//        return mainFolder().stringByAppendingPathComponent(directory)
        return String.init(format: "%ld/%ld/%ld.png",z,x,y)
//        return mainFolder().stringByAppendingPathComponent(directory)
    }
    
    func directoryForPath(path: MKTileOverlayPath) -> String
    {
        return self.directoryForComponents(path.z, x: path.x, y: path.y)
    }
    
    func directoryForComponents(z: Int, x: Int, y:Int) -> String
    {
        return String.init(format: "%ld/%ld",z,x)
//        return mainFolder().stringByAppendingPathComponent(directory)
    }
    
    
    override func loadTileAtPath(path: MKTileOverlayPath, result: (NSData?, NSError?) -> Void) {
        let url = URLForTilePath(path)
        

        if let cachedData = cache.objectForKey(url) as? NSData
        {
            print("using cache for " + String(path))
            result(cachedData, nil)
            return
        }
        else
        {
            NSLog("storagePath %@", self.storageForPath(path))
            let storagePath = self.mainFolder().stringByAppendingPathComponent(self.storageForPath(path))
            let  storageData: NSData? = NSData(contentsOfFile: storagePath)
            
            if (storageData != nil)
            {
                print("using storage for " + String(path))
                result(storageData, nil)
                return
            }
            else
            {
                print("loading " + String(path) + " from directory")
                Networking.sharedInstance.incrementCount()
                NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                    Networking.sharedInstance.decrementCount()
                    if error != nil
                    {
                        print(error)
                        return
                    }   
                    else
                    {
                        //let data: NSData =  NSData(contentsOfURL:url)!
                        self.cache.setObject(data!, forKey: url)
                        
                        do {
    //                        let folderPath = self.directoryForPath(path)
    //                        let folderPath = self.mainFolder().stringByAppendingPathComponent("/tiles/default/")
                            let folderPath = self.mainFolder().stringByAppendingPathComponent(self.directoryForPath(path))
                            try NSFileManager.defaultManager().createDirectoryAtPath(folderPath, withIntermediateDirectories: true, attributes: nil)
                            try data!.writeToFile(storagePath, options: .AtomicWrite)
                        }
                        catch {
                            print (error)
                            exit(-1)
                        }
                        result(data, nil)
                    }
                    
                }).resume()
                return
            }
        }
    }
    
}
