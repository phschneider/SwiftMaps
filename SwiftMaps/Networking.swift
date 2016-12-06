//
//  Networking.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 06.12.16.
//  Copyright © 2016 phschneider.net. All rights reserved.
//

import Foundation
import UIKit

class Networking {
    static let sharedInstance = Networking()
    
    private var _count : Int = 0             // _countx -> backing count
    var count : Int {
        set { _count = 2 * newValue
            if (count == 0)
            {
                hideTraffic()
            }
            else{
                showTraffic()
            }
        }
        get { return _count / 2 }
    }
    
    func incrementCount() {
        count += 1
    }
    
    func decrementCount() {
        count -= 1
    }
    
    private func showTraffic()
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    private func hideTraffic()
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
}