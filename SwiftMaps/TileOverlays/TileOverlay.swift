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
    var tileUseLoadbalancing:Bool = false
    
//    let cache: NSCache = NSCache<URL, Data:AnyObject >()
    
    override init(urlTemplate URLTemplate: String?) {
        super.init(urlTemplate: URLTemplate)
    }
    
    func name () -> String
    {
        return "default"
    }
    
    func mainFolder () -> NSString
    {
//        let docsDir:String = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0].absoluteString
//        let databasePath = docsDir.stringByAppendingFormat("tiles/%@", self.name())
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let databasePath =  dirPaths[0].appendingFormat("/tiles/%@", self.name())
        return databasePath as NSString;
    }
    
    func storageForPath(_ path: MKTileOverlayPath) -> String
    {
        return self.storageForComponents(path.z, x: path.x, y: path.y)
    }
    
    func storageForComponents(_ z: Int, x: Int, y:Int) -> String
    {
//        let directory = String.init(format: "%ld/%ld/%ld.png",z,x,y)
//        return mainFolder().stringByAppendingPathComponent(directory)
        return String.init(format: "%ld/%ld/%ld.png",z,x,y)
//        return mainFolder().stringByAppendingPathComponent(directory)
    }
    
    func directoryForPath(_ path: MKTileOverlayPath) -> String
    {
        return self.directoryForComponents(path.z, x: path.x, y: path.y)
    }
    
    func directoryForComponents(_ z: Int, x: Int, y:Int) -> String
    {
        return String.init(format: "%ld/%ld",z,x)
//        return mainFolder().stringByAppendingPathComponent(directory)
    }
    
    
    override func url(forTilePath path: MKTileOverlayPath) -> URL {
//        print("path \(path)")
        
        if (!self.tileUseLoadbalancing)
        {
            return super.url(forTilePath: path)
        }
        else
        {
            let url:URL = super.url(forTilePath: path)
            let array = ["a", "b", "c"]
            let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
            let loadBalancing:String = array[randomIndex] + "."
            let host = loadBalancing + url.host!
            
            let retUrl = URL.init(string: url.scheme!+"://"+host+url.path)!
//            print("retUrl \(retUrl)")
            return retUrl
        }
        
    }
    
    override func loadTile(at path: MKTileOverlayPath, result: @escaping (Data?, Error?) -> Void) {
        let url = self.url(forTilePath: path)
        

//        if let cachedData = cache.object(forKey: url) as? Data
//        {
//            print("using cache for " + String(describing: path))
//            result(cachedData, nil)
//            return
//        }
//        else
//        {
//            NSLog("storagePath %@", self.storageForPath(path))
            let storagePath = self.mainFolder().appendingPathComponent(self.storageForPath(path))
            let  storageData: Data? = try? Data(contentsOf: URL(fileURLWithPath: storagePath))
            
            if (storageData != nil)
            {
//                print("using storage for " + String(describing: path))
                result(storageData, nil)
                return
            }
            else
            {
//                print("loading " + String(describing: path) + " from directory")
//                print(url)
                Networking.sharedInstance.incrementCount()
                
                let session:URLSession
                if (self.name().contains("OpenPortGuid"))
                {
                    let sessionConfig = URLSessionConfiguration.default
                    let xHTTPAdditionalHeaders: [NSObject : AnyObject] = ["User-Agent" as NSObject:"SwiftMaps" as AnyObject]
                    sessionConfig.httpAdditionalHeaders = xHTTPAdditionalHeaders
                    session = URLSession(configuration: sessionConfig)
                }
                else
                {
                    session = URLSession.shared
                }

                session.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
                    Networking.sharedInstance.decrementCount()
                    if error != nil
                    {
                        print(error)
                        return
                    }   
                    else
                    {
                        //let data: NSData =  NSData(contentsOfURL:url)!
//                        self.cache.setObject(data!, forKey: url)
                        
                        do {
    //                        let folderPath = self.directoryForPath(path)
    //                        let folderPath = self.mainFolder().stringByAppendingPathComponent("/tiles/default/")
                            let folderPath = self.mainFolder().appendingPathComponent(self.directoryForPath(path))
                            try FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
                            try data!.write(to: URL(fileURLWithPath: storagePath), options: .atomicWrite)
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
//        }
    }
    
}
