//
//  Beacons.swift
//  testCustomObject
//
//  Created by MacMini on 2015/5/17.
//  Copyright (c) 2015年 Vincere. All rights reserved.
//

import UIKit

class Beacons: Node {
    
    var MAJOR : String!
    var MINOR : String!
    var UUID : String!
    var RSSI : Int!
    
    init(Major_Minor Identifier : String , RSSI rssi : Int)
    {
        super.init()
        
        self.MAJOR = (Identifier as NSString).substringToIndex(5)
        self.MINOR = (Identifier as NSString).substringWithRange(NSMakeRange(5, 5))
        self.UUID = Identifier
        
        self.RSSI = rssi
        
        
    }
}
