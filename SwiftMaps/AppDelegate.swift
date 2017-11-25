//
//  AppDelegate.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 09.07.16.
//  Copyright © 2016 phschneider.net. All rights reserved.
//

import UIKit
import CoreData
import AlamofireNetworkActivityIndicator

#if IS_SEGMENT_MAPS
    import StravaKit
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?
    var mapViewController: UIViewController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            print("Documents Directory %@", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
//            NSArray* cachePathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//            NSString* cachePath = [cachePathArray lastObject];
//            NSLog(@"Cache Directory: %@", cachePath);
        #endif
        
        // Override point for customization after application launch.
        NetworkActivityIndicatorManager.shared.isEnabled = true

        navigationController = UINavigationController()

        #if IS_TRAFFIC_MAPS
            mapViewController = TrafficMapViewController()
        #elseif IS_TOILETT_MAPS
            mapViewController = ToiletMapViewController()
        #elseif IS_ATM_MAPS
            mapViewController = ATMMapViewController()
        #elseif IS_PICNIC_MAPS
            mapViewController = PicnicMapsViewController()
        #elseif IS_SINGLETRAIL_MAPS
            mapViewController = SingleTrailMapViewController()
        #elseif IS_SEGMENT_MAPS
            mapViewController = SegmentMapsViewController()
        #elseif IS_NATURE_MAPS
            mapViewController = NatureMapViewController()
        #else
            mapViewController = MountainMapViewController()
        #endif
        
        self.navigationController!.pushViewController(mapViewController!, animated: false)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.rootViewController = navigationController
        self.window!.backgroundColor = UIColor.white
        self.window!.makeKeyAndVisible()

        #if (arch(i386) || arch(x86_64)) && os(iOS)
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let url = URL(fileURLWithPath: path)
            let filePath = url.appendingPathComponent("sample.xml").path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath)
            {
                print("FILE AVAILABLE %@",filePath)
            } else {
                print("FILE NOT AVAILABLE")
            }
        #endif
        
        self.initCoreDataRelations()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        #if IS_SEGMENT_MAPS
            return Strava.openURL(url, sourceApplication: sourceApplication)
        #endif
        return false
    }
    
    
    // MARK: - Helper
    func initCoreDataRelations()
    {
        // Save
        
        var tile:NSManagedObject
        if (UserDefaults.standard.bool(forKey: "StravaTileOverlayImported") == false)
        {
            tile = NSEntityDescription.insertNewObject(forEntityName: "Tile", into: managedObjectContext)
            tile.setValue("Strava", forKeyPath: "name")
            tile.setValue("StravaTileOverlay", forKeyPath: "classFileName")

            UserDefaults.standard.register(defaults: ["StravaTileOverlayImported" : true])
            UserDefaults.standard.set(true, forKey: "StravaTileOverlayImported")
            UserDefaults.standard.synchronize()
        }
        
        if (UserDefaults.standard.bool(forKey: "StravaPersonalTileOverlayImported") == false)
        {
            tile = NSEntityDescription.insertNewObject(forEntityName: "Tile", into: managedObjectContext)
            tile.setValue("Strava - Personal", forKeyPath: "name")
            tile.setValue("StravaPersonalTileOverlay", forKeyPath: "classFileName")
            
            UserDefaults.standard.register(defaults: ["StravaPersonalTileOverlayImported" : true])
            UserDefaults.standard.set(true, forKey: "StravaPersonalTileOverlayImported")
            UserDefaults.standard.synchronize()
        }

        if (UserDefaults.standard.bool(forKey: "StravaPersonalOverAllTileOverlayImported") == false)
        {
            tile = NSEntityDescription.insertNewObject(forEntityName: "Tile", into: managedObjectContext)
            tile.setValue("Strava - Personal Over All", forKeyPath: "name")
            tile.setValue("StravaPersonalOverAllTileOverlay", forKeyPath: "classFileName")
            
            UserDefaults.standard.register(defaults: ["StravaPersonalOverAllTileOverlayImported" : true])
            UserDefaults.standard.set(true, forKey: "StravaPersonalOverAllTileOverlayImported")
            UserDefaults.standard.synchronize()
        }
        
        if (UserDefaults.standard.bool(forKey: "DebugTileOverlayImported") == false)
        {
            tile = NSEntityDescription.insertNewObject(forEntityName: "Tile", into: managedObjectContext)
            tile.setValue("Debug", forKeyPath: "name")
            tile.setValue("DebugTileOverlay", forKeyPath: "classFileName")
            
            UserDefaults.standard.register(defaults: ["DebugTileOverlayImported" : true])
            UserDefaults.standard.set(true, forKey: "DebugTileOverlayImported")
            UserDefaults.standard.synchronize()
        }
        
  
        if (UserDefaults.standard.bool(forKey: "BlackAndWhiteTileOverlayImported") == false)
        {
            tile = NSEntityDescription.insertNewObject(forEntityName: "Tile", into: managedObjectContext)
            tile.setValue("Black & White", forKeyPath: "name")
            tile.setValue("BlackAndWhiteTileOverlay", forKeyPath: "classFileName")
            
            UserDefaults.standard.register(defaults: ["BlackAndWhiteTileOverlayImported" : true])
            UserDefaults.standard.set(true, forKey: "BlackAndWhiteTileOverlayImported")
            UserDefaults.standard.synchronize()
        }
        
        if (UserDefaults.standard.bool(forKey: "OsmHillShadingTileOverlayImported") == false)
        {
            tile = NSEntityDescription.insertNewObject(forEntityName: "Tile", into: managedObjectContext)
            tile.setValue("OSM HillShading", forKeyPath: "name")
            tile.setValue("OsmHillShadingTileOverlay", forKeyPath: "classFileName")
            
            UserDefaults.standard.register(defaults: ["OsmHillShadingTileOverlayImported" : true])
            UserDefaults.standard.set(true, forKey: "OsmHillShadingTileOverlayImported")
            UserDefaults.standard.synchronize()
        }
        
        if (UserDefaults.standard.bool(forKey: "OpenTopoMapTileOverlayImported") == false)
        {
            tile = NSEntityDescription.insertNewObject(forEntityName: "Tile", into: managedObjectContext)
            tile.setValue("Open Topo Map", forKeyPath: "name")
            tile.setValue("OpenTopoMapTileOverlay", forKeyPath: "classFileName")
            
            UserDefaults.standard.register(defaults: ["OpenTopoMapTileOverlayImported" : true])
            UserDefaults.standard.set(true, forKey: "OpenTopoMapTileOverlayImported")
            UserDefaults.standard.synchronize()
        }
        
        if (UserDefaults.standard.bool(forKey: "WaymarkedHikingTileOverlayImported") == false)
        {
            tile = NSEntityDescription.insertNewObject(forEntityName: "Tile", into: managedObjectContext)
            tile.setValue("Waymarked - Hiking", forKeyPath: "name")
            tile.setValue("WaymarkedHikingTileOverlay", forKeyPath: "classFileName")
            
            UserDefaults.standard.register(defaults: ["WaymarkedHikingTileOverlayImported" : true])
            UserDefaults.standard.set(true, forKey: "WaymarkedHikingTileOverlayImported")
            UserDefaults.standard.synchronize()
        }
        
        if (UserDefaults.standard.bool(forKey: "WaymarkedCyclingTileOverlayImported") == false)
        {
            tile = NSEntityDescription.insertNewObject(forEntityName: "Tile", into: managedObjectContext)
            tile.setValue("Waymarked - Cycling", forKeyPath: "name")
            tile.setValue("WaymarkedCyclingTileOverlay", forKeyPath: "classFileName")
            
            UserDefaults.standard.register(defaults: ["WaymarkedCyclingTileOverlayImported" : true])
            UserDefaults.standard.set(true, forKey: "WaymarkedCyclingTileOverlayImported")
            UserDefaults.standard.synchronize()
        }
        
        if (UserDefaults.standard.bool(forKey: "WaymarkedMtbTileOverlayImported") == false)
        {
            tile = NSEntityDescription.insertNewObject(forEntityName: "Tile", into: managedObjectContext)
            tile.setValue("Waymarked - MTB", forKeyPath: "name")
            tile.setValue("WaymarkedMtbTileOverlay", forKeyPath: "classFileName")
            
            UserDefaults.standard.register(defaults: ["WaymarkedMtbTileOverlayImported" : true])
            UserDefaults.standard.set(true, forKey: "WaymarkedMtbTileOverlayImported")
            UserDefaults.standard.synchronize()
        }
        
        if (UserDefaults.standard.bool(forKey: "KomootTileOverlayImported") == false)
        {
            tile = NSEntityDescription.insertNewObject(forEntityName: "Tile", into: managedObjectContext)
            tile.setValue("Komoot", forKeyPath: "name")
            tile.setValue("KomootTileOverlay", forKeyPath: "classFileName")
            
            UserDefaults.standard.register(defaults: ["KomootTileOverlayImported" : true])
            UserDefaults.standard.set(true, forKey: "KomootTileOverlayImported")
            UserDefaults.standard.synchronize()
        }
        
        if (UserDefaults.standard.bool(forKey: "MapBoxRunBikeHikeTileOverlayImported") == false)
        {
            tile = NSEntityDescription.insertNewObject(forEntityName: "Tile", into: managedObjectContext)
            tile.setValue("MapBox - RunBikeHike", forKeyPath: "name")
            tile.setValue("MapBoxRunBikeHikeTileOverlay", forKeyPath: "classFileName")
            
            UserDefaults.standard.register(defaults: ["MapBoxRunBikeHikeTileOverlayImported" : true])
            UserDefaults.standard.set(true, forKey: "MapBoxRunBikeHikeTileOverlayImported")
            UserDefaults.standard.synchronize()
        }
        
        if (UserDefaults.standard.bool(forKey: "MapBoxCustomTileOverlayImported") == false)
        {
            tile = NSEntityDescription.insertNewObject(forEntityName: "Tile", into: managedObjectContext)
            tile.setValue("MapBox - Custom", forKeyPath: "name")
            tile.setValue("MapBoxCustomTileOverlay", forKeyPath: "classFileName")
            
            UserDefaults.standard.register(defaults: ["MapBoxCustomTileOverlayImported" : true])
            UserDefaults.standard.set(true, forKey: "MapBoxCustomTileOverlayImported")
            UserDefaults.standard.synchronize()
        }
        
        if (UserDefaults.standard.bool(forKey: "MapBoxCustomPathTileOverlayImported") == false)
        {
            tile = NSEntityDescription.insertNewObject(forEntityName: "Tile", into: managedObjectContext)
            tile.setValue("MapBox - Custom Path", forKeyPath: "name")
            tile.setValue("MapBoxCustomPathTileOverlay", forKeyPath: "classFileName")
            
            UserDefaults.standard.register(defaults: ["MapBoxCustomPathTileOverlayImported" : true])
            UserDefaults.standard.set(true, forKey: "MapBoxCustomPathTileOverlayImported")
            UserDefaults.standard.synchronize()
        }
        
        if (UserDefaults.standard.bool(forKey: "MapBoxCustomHillContourTileOverlayImported") == false)
        {
            tile = NSEntityDescription.insertNewObject(forEntityName: "Tile", into: managedObjectContext)
            tile.setValue("MapBox - Custom Hill Contours", forKeyPath: "name")
            tile.setValue("MapBoxCustomHillContourTileOverlay", forKeyPath: "classFileName")
            
            UserDefaults.standard.register(defaults: ["MapBoxCustomHillContourTileOverlayImported" : true])
            UserDefaults.standard.set(true, forKey: "MapBoxCustomHillContourTileOverlayImported")
            UserDefaults.standard.synchronize()
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
        
        // Read
        let employeesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Tile")
        
        do {
            let fetchedEmployees = try managedObjectContext.fetch(employeesFetch) as! [Tile]
            
            for tile in fetchedEmployees {
                
                print(tile.name)
                
            }
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }

    }
    
    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "net.phschneider.SwiftMaps" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "SwiftMaps", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}

