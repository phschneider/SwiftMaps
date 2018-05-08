
//  ElevationView.swift
//  SingleTrailMaps
//
//  Created by Philip Schneider on 06.05.18.
//  Copyright © 2018 phschneider.net. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ElevationView: UIView {
    private var gpx:Gpx?
    var xFactor:CGFloat?
    var yFactor:CGFloat?
    var ySpace:CGFloat?
    var distanceFilter:CGFloat?
    var min:Double?
    var max:Double?
    var ySteps:CGFloat?
    var xSteps:CGFloat?

    init(frame: CGRect, gpx: Gpx) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        self.gpx = gpx
        self.max = self.gpx?.max()
        self.min = self.gpx?.min()
        
        self.ySteps = CGFloat(50)
        self.xSteps = CGFloat((self.gpx?.distanceInKm())!) / CGFloat(10)
        
        self.xFactor = self.frame.size.width / CGFloat((self.gpx?.distance())!)
        self.ySpace = CGFloat(20) //vom höchsten Punkt zum Rand // wirkt sich auch auf denyFactor aus ...
        self.yFactor = (self.frame.size.height-ySpace!) / CGFloat(max!)
        
        self.distanceFilter = CGFloat((self.gpx?.distanceInKm())!*10.0)*xFactor! // Glättung
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
//        if (self.gpx != nil)
//        {
            self.createProfile()
            self.createRulers()
//        }
    }
    
    // MARK: - Custom ...
    func createProfile() {
        let path = UIBezierPath()
        let contour = UIBezierPath()
        path.move(to: CGPoint(x: 0.0, y: self.frame.size.height))
        
        var distance=CGFloat(0)
        var lastLocation:CLLocation?
        let locations=(gpx?.locations())!
        for location in locations
        {
            if(lastLocation != nil)
            {
                distance += CGFloat((location.distance(from: lastLocation!))) * self.xFactor!
            }
            
            if ( distance == 0 ||
                (distance > 0 && Int(distance) % Int(self.distanceFilter!) == 0) ||
                 locations.last == location
               )
            {
                let height = self.heightForAltitude(alt: CGFloat(location.altitude))
                path.addLine(to: CGPoint(x: distance, y: height))
                
                if (locations.first == location)
                {
                    contour.move(to: CGPoint(x: distance, y: height))
                }
                else
                {
                    contour.addLine(to: CGPoint(x: distance, y: height))
                }
            }
            lastLocation = location
        }
        
        path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        path.close()
        
        UIColor.darkGray.setFill()
        path.fill()
        
        UIColor.green.setStroke()
        contour.lineWidth = CGFloat(2.5)
        contour.lineJoinStyle =  CGLineJoin.round
        contour.stroke()
    }
    
    func heightForAltitude(alt:CGFloat) -> CGFloat
    {
        let height = self.frame.size.height  - (alt * self.yFactor!)
        return height;
    }
    
    
    func altitudeForPixelHeight(height: CGFloat) -> CGFloat
    {
        let height = (self.frame.size.height-height) / self.yFactor!
        return height;
    }
    
    func widthForDistance(distance:CGFloat) -> CGFloat
    {
        let height = (distance * 1000 * self.xFactor!)
        return height;
    }
    
    func createRulers() {
//        let yForMaxHeight = self.heightForAltitude(alt: CGFloat(self.max!))
//        let yHeightForMaxAlt = self.altitudeForPixelHeight(height: yForMaxHeight)
        let limit = self.altitudeForPixelHeight(height:0)
        
        for i in stride(from: Int(self.ySteps!), to: Int(limit), by: Int(self.ySteps!)) {
            self.createHorizontalRuleFor(height: CGFloat(i))
        }
        
        for i in stride(from: Int(self.xSteps!), to: Int((self.gpx?.distanceInKm())!), by: Int(self.xSteps!))
        {
            print( " Step Vertical \(i)" )
            self.createVerticalRuleFor(width: CGFloat(i))
        }
        
        self.createVerticalScale()
    }
    
    func createHorizontalRuleFor(height:CGFloat)
    {
        let y = self.heightForAltitude(alt:height)
     
        UIColor.lightGray.setStroke()
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: CGFloat(0.0), y: y))
        path.addLine(to: CGPoint(x:self.frame.size.width, y: y))
        
        var dashes: [CGFloat] = [10, 5]
        
        // Plug it into the Bezier path
        path.setLineDash(&dashes, count: dashes.count, phase: 0)
        path.stroke()
    }
    
    func createVerticalRuleFor(width:CGFloat)
    {
        let x = self.widthForDistance(distance:width)
        
        UIColor.lightGray.setStroke()
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: CGFloat(x), y: 0.0))
        path.addLine(to: CGPoint(x:CGFloat(x), y: self.frame.size.height))
        
        print( "\(x),0.0 =>  \(x),\(self.frame.size.height)" )
        var dashes: [CGFloat] = [10, 5]
        
        // Plug it into the Bezier path
        path.setLineDash(&dashes, count: dashes.count, phase: 0)
        path.stroke()
    }
    
    func createVerticalScale()
    {
        let width=self.widthForDistance(distance:self.xSteps!)
//        let width = self.xSteps! * 2.0

        let height=self.frame.size.height-CGFloat(10)
        let max = Int((self.gpx?.distanceInKm())!)
//        let steps =  Int( (self.gpx?.distanceInKm())!/Double(self.xSteps!))
        let steps =  Int( self.xSteps!)

        for i in stride(from: 0, to: max, by:steps) {

            UIColor.black.setStroke()
            
            let path = UIBezierPath()
            let x = CGFloat(i)/self.xSteps! * (width)
            
            path.move(to: CGPoint(x: x, y: self.frame.size.height))
            path.addLine(to: CGPoint(x: x, y:height ))
            path.addLine(to: CGPoint(x: x+CGFloat(width), y: height ))
            path.addLine(to: CGPoint(x: x+CGFloat(width), y: self.frame.size.height ))
            path.addLine(to: CGPoint(x: x, y: self.frame.size.height ))
//            path.close()
            
            print("x:\(x) width:\(width) i \(i) Distance:\(((self.gpx?.distanceInKm())!)) Steps:\(self.xSteps) Stepsize:\(self.frame.size.width/self.xSteps!)")
            
            if ( (i/Int(self.xSteps!))%2 == 0)
            {
                UIColor.white.setFill()
            }
            else
            {
                UIColor.black.setFill()
            }
            path.fill()
            path.stroke()
        }
    }
}

