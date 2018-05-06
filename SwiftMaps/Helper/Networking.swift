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
    
    fileprivate var _count : Int = 0             // _countx -> backing count
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
    
    fileprivate func showTraffic()
    {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    fileprivate func hideTraffic()
    {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }    }
    
}
