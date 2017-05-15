//
//  Weather.swift
//  EandXSwift
//
//  Created by Richard Adem on 14/5/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import Foundation
import SwiftyJSON

class Weather {
    var name:String?
    var degrees:Double?
    
    init(json: [String: Any]) {
        self.name = json["name"] as! String
        
        let main = json["main"] as! [String: Any]
        
        self.degrees = main["temp"] as! Double
    }
}
