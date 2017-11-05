//
//  TileViewController.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 02.11.17.
//  Copyright © 2017 phschneider.net. All rights reserved.
//

import Foundation

//class TileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    
//    var tableView: UITableView
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.title = "Tiles"
//        
//        self.tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LabelCell")
//        
//        super.init(nibName: nil, bundle: nil)
//        self.view.addSubview(self.tableView)
//        
//        self.tableView.delegate = self;
//        self.tableView.dataSource = self;
//    }
//
//    // MARK: TableView
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let reuseIdentifier = "LabelCell"
//        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
//        
//        switch indexPath.section {
//        case 0:
//            let tag = self.node.tag[indexPath.row]
//            
//            cell.textLabel?.text = tag._k
//            cell.detailTextLabel?.text = tag._v
//            break
//            
//        case 1:
//            cell.textLabel?.text = "Distance"
//            if ((self.userLocation) != nil)
//            {
//                let nodeLocation:CLLocation = CLLocation.init(latitude: Double(node._lat!), longitude: Double(node._lon!))
//                let myLocation:CLLocationDistance = (self.userLocation!.distance(from: nodeLocation))
//                cell.detailTextLabel?.text = String(Double(round(100*myLocation)/100))
//            }
//            break
//        default: break
//            
//        }
//        
//        return cell
//    }
//}
