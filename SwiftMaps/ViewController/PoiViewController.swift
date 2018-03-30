//
//  PoiViewController.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 30.03.18.
//  Copyright © 2018 phschneider.net. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PoiViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    var mapViewController: MapViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    var _fetchedResultsController: NSFetchedResultsController<Poi>? = nil
    var tableView: UITableView
    
    convenience init() {
        self.init(imageURL: nil)
    }
    
    init(imageURL: NSURL?) {
        self.tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.grouped)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LabelCell")
        
        
        
        //self.imageURL = imageURL
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    override func loadView() {
    //        self.title = "Tiles"
    //
    //
    //        // super.init(nibName: nil, bundle: nil)
    //        self.view.addSubview(self.tableView)
    //
    //        self.tableView.delegate = self;
    //        self.tableView.dataSource = self;
    //
    ////        // Load core Data stack ...
    ////
    ////
    ////        let employeesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Tile")
    ////
    ////        do {
    ////            let fetchedEmployees = try managedObjectContext.fetch(employeesFetch)
    ////        } catch {
    ////            fatalError("Failed to fetch employees: \(error)")
    ////        }
    //
    //    }
    
    override func viewDidLoad() {
        self.title = "POIs"
        
        self.tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.grouped)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LabelCell")
        self.tableView.frame = self.view.frame;
        self.tableView.autoresizingMask = self.view.autoresizingMask;
        // super.init(nibName: nil, bundle: nil)
        self.view.addSubview(self.tableView)
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        //        // Load core Data stack ...
        //
        //
        //        let employeesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Tile")
        //
        //        do {
        //            let fetchedEmployees = try managedObjectContext.fetch(employeesFetch)
        //        } catch {
        //            fatalError("Failed to fetch employees: \(error)")
        //        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(edit))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(close))
    }
    
    // MARK: Button Actions
    @objc func edit(){
        self.tableView.setEditing(!(self.tableView.isEditing), animated: true)
    }
    
    @objc func close(){
        //TODO: Hier muss man prüfen ob wir über Modal angezeigt werden oder normal ...
        
        let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedObjectContext = appDel.managedObjectContext
        
        do {
            try self.managedObjectContext?.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
        
        NotificationCenter.default.post(name:Notification.Name(rawValue:"PoiSelectionClosed"), object: nil,userInfo:nil)
        
        self.navigationController?.dismiss(animated: true, completion: {
        })
        
        self.navigationController?.willMove(toParentViewController: nil);
        self.navigationController?.view.removeFromSuperview();
        self.navigationController?.didMove(toParentViewController: nil);
    }
    
    // MARK: TableView
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    // ????
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }

// TODO: Potentieller Fehler, wenn alle Ausgewählt, oder keines ausgewählt ist, gibt es nur eine Section ...
       func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

           let poi = self.fetchedResultsController.object(at: indexPath)
           let deleteAction  = UITableViewRowAction(style: .destructive, title: "Clear cache") { (rowAction, indexPath) in
           }

           let refreshAction  = UITableViewRowAction(style: .normal, title: "Refresh ") { (rowAction, indexPath) in

               if (poi.enabled?.boolValue)! {
                   Api().requestForCurrentMapRect(String(format: "node[%@=%@]",poi.category!, poi.type!), mapView: (self.mapViewController?.mapView)!, gpxTrack: self.mapViewController?.gpx)
               }
           }

        return [deleteAction, refreshAction]

    }
    
    // MARK: - MOVE
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        
//        // Es kann nur innerhalb der gleichen Section Sortiert werden
//        if (sourceIndexPath.section != destinationIndexPath.section)
//        {
//            tableView.reloadData()
//            return
//        }
//        
//        let sourceTile = fetchedResultsController.object(at: sourceIndexPath)
//        let destinationTile = fetchedResultsController.object(at: destinationIndexPath)
//        
//        let sourceSortOrder = sourceTile.sortOrder
//        sourceTile.sortOrder = destinationTile.sortOrder
//        destinationTile.sortOrder = sourceSortOrder
//        
//        if ((sourceTile.enabled?.boolValue)! || (destinationTile.enabled?.boolValue)!)
//        {
//            NotificationCenter.default.post(name:Notification.Name(rawValue:"PoiSelectionChanged"), object: nil,userInfo:nil)
//        }
//    }


    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let sectionInfo = fetchedResultsController.sections![indexPath.section]
        if (sectionInfo.numberOfObjects > 1)
        {
            return true
        }
        return false
    }
    
    // MARK: - DATA SOURCE
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
        //        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
        //        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "LabelCell"
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        let poi = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.adjustsFontSizeToFitWidth = true
//        let p = (node as AnyObject).value(forKey: "type") as! String
//        print(p)
         cell.textLabel!.text = poi.type!.description
//        cell.textLabel!.text = p
        cell.selectionStyle = .none

        if (poi.enabled?.boolValue)!
        {
            cell.accessoryType = .checkmark;
        }
        else
        {
            cell.accessoryType = .none;
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let poi = fetchedResultsController.object(at: indexPath)
        poi.enabled = !(poi.enabled?.boolValue)! as NSNumber

        //tableView.reloadRows(at: [indexPath], with: .automatic)
        let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedObjectContext = appDel.managedObjectContext

        do {
            try self.managedObjectContext?.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }

        _fetchedResultsController = nil
        tableView.reloadData()

        NotificationCenter.default.post(name:Notification.Name(rawValue:"PoiSelectionChanged"), object: nil,userInfo:nil)
    }

    
    // MARK: - CoreData
    var fetchedResultsController: NSFetchedResultsController<Poi> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Poi> = Poi.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptorEnabled = NSSortDescriptor(key: "enabled", ascending: false)
        let sortDescriptorSortOrder = NSSortDescriptor(key: "sortOrder", ascending: false)

        fetchRequest.sortDescriptors = [sortDescriptorEnabled, sortDescriptorSortOrder]

        let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedObjectContext = appDel.managedObjectContext
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: "enabled", cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
}
