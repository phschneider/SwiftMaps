//
//  PersonalStravaTileOverlay.swift
//  SwiftMaps
//
//  Created by Philip Schneider on 02.11.17.
//  Copyright © 2017 phschneider.net. All rights reserved.
//

import Foundation

class StravaPersonalTileOverlay: StravaTileOverlay {
    convenience init() {
        // https://d22umfi1yqsdc.cloudfront.net/tiles/01000000008FFE1328627D86-4BF4966F/8-132-88.png?1509281905
        self.init(urlTemplate:"https://d22umfi1yqsdc.cloudfront.net/tiles/01000000008FFE1328627D86-4BF4966F/{z}-{x}-{y}.png")
    }
    
    override func name () -> String
    {
        return "strava-bike-personal-2017"
    }
}
