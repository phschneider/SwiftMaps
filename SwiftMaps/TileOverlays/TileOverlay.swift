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

        let url: URL = super.url(forTilePath: path)
        if (!self.tileUseLoadbalancing)
        {
            if (url.host == "tiles.lyrk.org") {
                let host = url.host!
                let urlString = URL.init(string: url.scheme!+"://"+host+url.path + "?apikey=64fbc258da5d4c1897f4332b67866b46")!.absoluteString

                return URL.init(string:urlString.replacingOccurrences(of: ".png?apikey=", with: "?apikey="))!
            }
            else
            {

            }
            return super.url(forTilePath: path)
        }
        else {
            let array = ["a", "b", "c"]
            let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
            let loadBalancing: String = array[randomIndex] + "."
            let host = loadBalancing + url.host!


            var retUrl:URL
            if (url.host == "tile.thunderforest.com") {
                retUrl = URL.init(string: url.scheme!+"://"+host+url.path + "?apikey=a5dd6a2f1c934394bce6b0fb077203eb")!
            }
            else
            {
                retUrl = URL.init(string: url.scheme!+"://"+host+url.path)!
            }


//            print("retUrl \(retUrl)")
            return retUrl
        }
        
    }
    
    override func loadTile(at path: MKTileOverlayPath, result: @escaping (Data?, Error?) -> Void) {
        #if DEBUG
            print("Function: \(#function), line: \(#line)")
        #endif
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
                #if DEBUG
                    print("using storage for \(storagePath) " + String(describing: path))
                #endif
                result(storageData, nil)
                return
            }
            else
            {
                
//                print("loading " + String(describing: path) + " from directory")
//                print(url)
                Networking.sharedInstance.incrementCount()
                
                var session:URLSession
                if (self.name().contains("OpenPortGuid"))
                {
                    let sessionConfig = URLSessionConfiguration.default
                    let xHTTPAdditionalHeaders: [NSObject : AnyObject] = ["User-Agent" as NSObject:"SwiftMaps" as AnyObject]
                    
                    sessionConfig.httpAdditionalHeaders = xHTTPAdditionalHeaders
                    // IGNORE CACHE ...
                    sessionConfig.requestCachePolicy = .reloadIgnoringLocalCacheData
                    sessionConfig.urlCache = nil
                    
                    session = URLSession(configuration: sessionConfig)
                }
                else
                {
                    let sessionConfig = URLSessionConfiguration.default
                    
//                    let cache = URLCache(memoryCapacity:16384, diskCapacity: 268435456, diskPath: self.name())
//                    sessionConfig.urlCache = cache
//                    sessionConfig.requestCachePolicy = .useProtocolCachePolicy

                    // IGNORE CACHE ...
                    sessionConfig.requestCachePolicy = .reloadIgnoringLocalCacheData
                    sessionConfig.urlCache = nil
                    
                    session = URLSession(configuration: sessionConfig)
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
                            #if DEBUG
                                print("path \(storagePath) " + String(describing: path))
                            #endif
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
