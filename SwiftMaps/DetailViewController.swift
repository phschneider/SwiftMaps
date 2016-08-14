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
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(node:Node)
    {
        self.node = node
        
        self.tableView = UITableView.init(frame: CGRectZero, style: UITableViewStyle.Plain)
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "LabelCell")
        
        super.init(nibName: nil, bundle: nil)
        self.view.addSubview(self.tableView)
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.frame = self.view.frame
    }
    
    // MARK: HeaderView
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 250.0
    }
    
    // MARK: TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.node.tag.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "LabelCell"
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
        
        let tag = self.node.tag[indexPath.row]
        
        cell.textLabel?.text = tag._k
        cell.detailTextLabel?.text = tag._v
        
        return cell
    }
}
