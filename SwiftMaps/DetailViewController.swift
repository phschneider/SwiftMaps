//
//  DetailViewController.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 14.08.16.
//  Copyright © 2016 phschneider.net. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class DetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    var node: Node!
    var tableView: UITableView
    let locationManager = CLLocationManager()
    var userLocation:CLLocation?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // TODO: wikipedia links
    init(node:Node)
    {
        self.node = node
        
        self.tableView = UITableView.init(frame: CGRectZero, style: UITableViewStyle.Plain)
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "LabelCell")
        
        super.init(nibName: nil, bundle: nil)
        self.view.addSubview(self.tableView)
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.title = node.title()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.frame = self.view.frame
    }
    
    // MARK: HeaderView
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == 0)
        {
            let mapView = MKMapView()
            
            let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(node._lat!), longitude: Double(node._lon!))
            
            let anotation = MKPointAnnotation()
            anotation.coordinate = location
            //                                    anotation.title = "The Location"
            
            mapView .addAnnotation(anotation)
            
            let meter = 50.0
            var region: MKCoordinateRegion
            region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(location.latitude, location.longitude), meter, meter)
            
            mapView.setRegion(region, animated: false)
            
            return mapView
        }
        return nil
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0)
        {
            return 250.0
        }
        return tableView.rowHeight
    }
    
    // MARK: TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0)
        {
            return self.node.tag.count
        }

        return 1
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0] 
        self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "LabelCell"
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
        
        switch indexPath.section {
        case 0:
            let tag = self.node.tag[indexPath.row]
            
            cell.textLabel?.text = tag._k
            cell.detailTextLabel?.text = tag._v
            break
            
        case 1:
            cell.textLabel?.text = "Distance"
            if ((self.userLocation) != nil)
            {
                let nodeLocation:CLLocation = CLLocation.init(latitude: Double(node._lat!), longitude: Double(node._lon!))
                let myLocation:CLLocationDistance = (self.userLocation!.distanceFromLocation(nodeLocation))
                cell.detailTextLabel?.text = String(Double(round(100*myLocation)/100))
            }
            break
        default: break
            
        }
        
        return cell
    }
}
