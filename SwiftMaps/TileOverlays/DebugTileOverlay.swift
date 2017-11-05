//
//  DebugTileOverlay.swift
//  
//
//  Created by Philip Schneider on 03.11.17.
//
//

import Foundation
import MapKit

class DebugTileOverlay: TileOverlay {
//    convenience init() {
//        let array = ["a", "b", "c"]
//        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
//        self.init(urlTemplate:"https://" + array[randomIndex] + ".tile.hosted.thunderforest.com/komoot-2/{z}/{x}/{y}.png")
//    }
    
    override init(urlTemplate URLTemplate: String?) {
        super.init(urlTemplate: URLTemplate)
        self.canReplaceMapContent = false;
    }
    
    override func name () -> String
    {
        return "debug"
    }
    
    override func loadTile(at path: MKTileOverlayPath, result: @escaping (Data?, Error?) -> Void) {

        let sz = self.tileSize;
        let rect = CGRect(x:0,y:0,width:sz.width,height:sz.height);
        
        UIGraphicsBeginImageContext(sz);
        let ctx = UIGraphicsGetCurrentContext();
        UIColor.black.setStroke();
        
        ctx!.setLineWidth(1.0);
        ctx!.stroke(rect);
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attrs = [NSFontAttributeName: UIFont.systemFont(ofSize: 20.0), NSForegroundColorAttributeName: UIColor.black]
        let string = String.init(format: "X=%ld\nY=%ld\nZ=%ld",path.x,path.y,path.z);

        string.draw(with: rect, options: .usesLineFragmentOrigin, attributes: attrs, context: nil)

        let tileImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        let tileData = UIImagePNGRepresentation(tileImage!);
        result(tileData,nil);

    }
}

