//
//  AlertController.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 20.11.16.
//  Copyright © 2016 phschneider.net. All rights reserved.
//

import Foundation
import UIKit

class AlertController {
    
    // MARK: Helper
    func showAlert(_ message: String)
    {
        // WARNING: Mögliche doppelte alerts
        let alert = UIAlertController(title: "Alert",
                                      message: message as String,
                                      preferredStyle: UIAlertControllerStyle.alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        alert.addAction(OKAction)
  
        //
        let window:UIWindow = UIWindow.init(frame: UIScreen.main.bounds)
        let viewController:UIViewController = UIViewController();
        viewController.view.frame = window.frame;
        
        window.backgroundColor = UIColor.white;
        window.windowLevel = UIWindowLevelAlert;
        
        window.rootViewController=viewController;
        window.makeKeyAndVisible();
    
        viewController.present(alert, animated: true, completion:nil)
    }
}
