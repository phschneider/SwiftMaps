//
//  PersonalOverAllStravaTileOverlay.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 10.11.17.
//  Copyright © 2017 phschneider.net. All rights reserved.
//

import Foundation

class PersonalOverAllStravaTileOverlay: StravaTileOverlay {
    convenience init() {
        // https://d22umfi1yqsdc.cloudfront.net/tiles/01000000008FFE130D5E82CC-7762E7F1/12-2129-1404.png?1509831917    
        self.init(urlTemplate:"https://d22umfi1yqsdc.cloudfront.net/tiles/01000000008FFE130D5E82CC-7762E7F1/{z}-{x}-{y}.png")
    }
    
    override func name () -> String
    {
        return "strava-bike-personal-over-all"
    }
}
