//
//  Node.swift
//  testCustomObject
//
//  Created by MacMini on 2015/5/17.
//  Copyright (c) 2015年 Vincere. All rights reserved.
//

import UIKit

class Node: NSObject {
    
//    var ID : NSString!
    var PARENT : Int!
    var PREV : Int!
    var NEXT : Int!
    var INDEX : Int!
    
    override init()
    {
        self.PARENT = -1
        self.PREV   = -1
        self.NEXT   = -1
        self.INDEX  = -1
    }
    
    init(Parent _PARENT:Int, Previous _PREV:Int, Next _NEXT:Int, Index _INDEX:Int)
    {
        super.init()

        self.PARENT = _PARENT
        self.PREV   = _PREV
        self.NEXT   = _NEXT
        self.INDEX  = _INDEX
    }
    
    func setParent(Parent _PARENT:Int)
    {
        self.PARENT = _PARENT
    }
    
    func setPrevious(Previous _PREV:Int)
    {
        self.PREV = _PREV
    }
    
    func setNext(Next _NEXT:Int)
    {
        self.NEXT = _NEXT
    }
    
    func setIndex(Index _INDEX:Int)
    {
        self.INDEX = _INDEX
    }
    
    func getCollections(C_ID _ID:NSString) -> [Collections]
    {
        var CollectionArray = [Collections]()
        
        return CollectionArray
    }
    
    func getBeacons(B_ID _ID:NSString) -> [Beacons]
    {
        var BeaconArray = [Beacons]()
        
        return BeaconArray
    }
    

}
