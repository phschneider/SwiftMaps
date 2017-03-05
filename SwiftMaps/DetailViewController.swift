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
        
        self.tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LabelCell")
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.frame = self.view.frame
    }
    
    // MARK: HeaderView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0)
        {
            return 250.0
        }
        return tableView.rowHeight
    }
    
    // MARK: TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0)
        {
            return self.node.tag.count
        }

        return 1
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0] 
        self.tableView.reloadSections(IndexSet(integer: 1), with: UITableViewRowAnimation.automatic)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "LabelCell"
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        
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
                let myLocation:CLLocationDistance = (self.userLocation!.distance(from: nodeLocation))
                cell.detailTextLabel?.text = String(Double(round(100*myLocation)/100))
            }
            break
        default: break
            
        }
        
        return cell
    }
}
