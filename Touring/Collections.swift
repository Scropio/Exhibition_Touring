//
//  Collections.swift
//  testCustomObject
//
//  Created by MacMini on 2015/5/17.
//  Copyright (c) 2015年 Vincere. All rights reserved.
//

import UIKit

class Collections: Node {
    
    var C_ID : String!
    var C_NAME : String!
    var C_NAME_CHT : String!
    
    var C_JSON : JSON!
    
    var COLLECTs = [Collections]()
    var BEACONs = [Beacons]()
    var VISITOR : Bool!
    var GHOST : Bool!
    var Root : Bool!
    
    var Structure = [Collections]()
    
    private var AllVisitor : Bool!
    private var FlatCollectionArray = [Collections]()
    
    
    init(ID _ID:String,Parent _PARENT:Int)
    {
        super.init()
        self.C_ID = _ID
        self.C_NAME = ""
        self.C_NAME_CHT = ""
        
        self.PARENT = _PARENT
        self.PREV = -1
        self.INDEX = -1
        self.NEXT = -1
        
        self.VISITOR = false
        self.GHOST = false
        self.Root = false
    }
    
    init(Json json : JSON, Parent _PARENT:Int, Index _Index:Int, isRoot _root:Bool)
    {
        super.init()
        
        self.C_ID       = json["_id"].string!
        
        self.C_JSON     = json
        
        json["name"]["text"]        != nil ? (self.C_NAME = json["name"]["text"].string!)     : (self.C_NAME = "")
        json["name"]["text_cht"]    != nil ? (self.C_NAME_CHT = json["name"]["text_cht"].string!) : (self.C_NAME_CHT = "")
        
        self.PARENT     = _PARENT
        self.INDEX      = _Index
        self.PREV       = _Index - 1
        self.NEXT       = _Index + 1
        
        self.Root       = _root
        
        json["ghost"].bool != nil ? (self.GHOST = json["ghost"].bool!) : (self.GHOST = false)
        
        if json["ibeacons"].count > 0
        {
            for var i = 0 ; i < json["ibeacons"].count ; i++
            {
                var cBeacon : Beacons = Beacons(Major_Minor: json["ibeacons"][i]["uuid"].string! , RSSI: json["ibeacons"][i]["rssi"].int!)
                self.BEACONs.append(cBeacon)
            }
        }

        self.VISITOR    = false
        
        NSLog("ID:%@ Name:%@ CHT:%@ INDEX:%d PARENT:%d PREV:%d NEXT:%d Ghost:%@",
            self.C_ID,
            self.C_NAME,
            self.C_NAME_CHT,
            self.INDEX,
            self.PARENT,
            self.PREV,
            self.NEXT,
            self.GHOST)
    }
    
    init(ID _ID:String,Parent _PARENT:Int,Index _Index:Int ,isRoot _root:Bool)
    {
        super.init()
        self.C_ID = _ID
        self.C_NAME = ""
        self.C_NAME_CHT = ""
        
        self.PARENT = _PARENT
        self.PREV = -1
        self.INDEX = _Index
        self.NEXT = -1
        
        self.VISITOR = false
        self.GHOST = false
        self.Root = _root
    }
    
    //尋找最上層的父節點
    //findParent(現在的節點,節點路徑) -> 節點路徑
    func findParent(Node _Node:Collections, Path _Path:Collections) -> Collections
    {
        var cNode : Collections = _Node
        
        if _Node.PARENT == -1
        {
            return Structure[0]
        }
        else
        {
            if !Structure[_Node.PARENT].VISITOR
            {
                cNode = Structure[_Node.PARENT]
                _Path.COLLECTs.append(cNode)
                return findParent(Node: cNode,Path: _Path)
            }
            else
            {
                return Structure[_Node.INDEX]
            }
        }
    }
    
    func FindCollections(NodeID ID:String) -> Collections
    {
        if self.C_ID != ID
        {
            for var i = 0 ; i < self.COLLECTs.count ; i++
            {
                if self.COLLECTs[i].C_ID == ID
                {
                    return self.COLLECTs[i]
                }
                else
                {
                    for var j = 0 ; j < self.COLLECTs[i].COLLECTs.count ; j++
                    {
                        if self.COLLECTs[i].COLLECTs[j].C_ID == ID
                        {
                            return self.COLLECTs[i].COLLECTs[j]
                        }
                        else
                        {
                            for var k = 0 ; k < self.COLLECTs[i].COLLECTs[j].COLLECTs.count ; k++
                            {
                                if self.COLLECTs[i].COLLECTs[j].COLLECTs[k].C_ID == ID
                                {
                                    return self.COLLECTs[i].COLLECTs[j].COLLECTs[k]
                                }
                            }
                        }
                    }
                }
            }
        }
        return self
    }
    
    private var RecommandList : [Collections] = [Collections]()
    private var HistoryList   : [Collections] = [Collections]()
    private var PreParentList : [Collections] = [Collections]()
    
    func getHistoryList() ->[Collections]
    {
        return HistoryList
    }
    
    func getRecommandList() -> [Collections]
    {
        return RecommandList
    }
    
    func ChangePosition(Collection Node : String)
    {
        var currentNode : Collections = findNode(Node_ID: Node)
        
        var cNode : Collections = Structure[currentNode.INDEX]
        
        var pPath : Collections = Collections(ID: "Recommand", Parent: -1)
        
        var nextNode : Collections!
        var prevNode : Collections!
        var parNode : Collections!
        
        //Preprocessor Start
        for var i = 0 ; i < PreParentList.count ; i++
        {
            Structure[PreParentList[i].INDEX].VISITOR = true
            var FindHistory : Bool = false
            
            for var j = 0 ; j < HistoryList.count ; j++
            {
                if HistoryList[j] == PreParentList[i]
                {
                    FindHistory = true
                    break
                }
            }
            
            if !FindHistory
            {
                if PreParentList[i].GHOST == false
                {
                    HistoryList.append(PreParentList[i])
                }
            }
        }
        //GHOST Process
        if PreParentList.count > 0
        {
            var GhostGroup : [Collections] =  LeaveNode(PreviousNode: PreParentList[0])
            
            println("Preparent!!!  " + PreParentList[0].C_NAME)
            for var i = 0 ; i < GhostGroup.count ; i++
            {
                HistoryList.append(GhostGroup[i])
            }
        }
        
        PreParentList = [Collections]()
        RecommandList = [Collections]()
        //Preprocessor End
        
        Structure[cNode.INDEX].VISITOR = true
        PreParentList.append(cNode)
        RecommandList.append(cNode)
        
        //Find Parent Start
        parNode = findParent(Node: cNode, Path: pPath)
        
        for var i = 0 ; i < pPath.COLLECTs.count; i++
        {
            PreParentList.append(pPath.COLLECTs[i])
            RecommandList.append(pPath.COLLECTs[i])
            
            //            println("RecommandList[" + String(i) + "]:" + pPath.COLLECTs[i].C_NAME)
        }
        //Find Parent End
        
        //反轉推薦序列
        RecommandList = RecommandList.reverse()
        
        //Find Next + Find Parent Start
        
        if RecommandList.count == 1
        {
            if HistoryList.count > 0
            {
                nextNode = findNext(CurrentNode: cNode.C_ID, PreviousNode: HistoryList[0].C_ID)
            }
            else
            {
                nextNode = findNext(CurrentNode: cNode.C_ID, PreviousNode: Structure[0].C_ID)
            }
            //            NSLog("nextNode:%d",nextNode.INDEX)
            
            parNode = findParent(Node: nextNode, Path: pPath)
            
            for var i = 0 ; i < pPath.COLLECTs.count - 1 ; i++
            {
                RecommandList.append(pPath.COLLECTs[i])
            }
            
            RecommandList.append(parNode)
        }
        
        //產生推薦序列
        var FullRecommand : [Collections] = []
        
        for var i = 0 ; i < Structure.count ; i++
        {
            cNode = Structure[cNode.NEXT % Structure.count]
            
            if !cNode.VISITOR
            {
                FullRecommand.append(cNode)
            }
        }
        
        for var i = 0 ; i < RecommandList.count ; i++
        {
            for var j = 0 ; j < FullRecommand.count ; j++
            {
                if RecommandList[i] == FullRecommand[j]
                {
                    FullRecommand.removeAtIndex(j)
                }
            }
        }
        
        for var i = 0 ; i < FullRecommand.count-1; i++
        {
            RecommandList.append(FullRecommand[i])
        }
        
        for var i = 0 ; i < HistoryList.count ; i++
        {
            if HistoryList[i].GHOST == true
            {
                HistoryList.removeAtIndex(i)
            }
        }
        
        for var i = 0 ; i < RecommandList.count ; i++
        {
            if RecommandList[i].GHOST == true
            {
                RecommandList.removeAtIndex(i)
            }
        }
    }
    
    func printStructure()
    {
        println("-----------PRINT STRUCTURE----------")
        print("Index:" + String(self.INDEX))
        print(" Name:" + self.C_ID)
        print(" PARENT:" + String(self.PARENT))
        print(" Prev:" + String(self.PREV))
        print(" Next:" + String(self.NEXT))
        print(String(format:" Ghost:%@" ,self.GHOST))
        println(String(format:" isVISITOR:%@" ,self.VISITOR))
        
        for var i = 0 ; i < self.COLLECTs.count ; i++
        {
            var lv1Node = self.COLLECTs[i]
            
            print("    Index:" + String(lv1Node.INDEX))
            print(" Name:" + lv1Node.C_ID)
            print(" PARENT:" + String(lv1Node.PARENT))
            print(" Prev:" + String(lv1Node.PREV))
            print(" Next:" + String(lv1Node.NEXT))
            print(String(format:" Ghost:%@" ,lv1Node.GHOST))
            print(String(format:" isVISITOR:%@" ,lv1Node.VISITOR))
            println()
            
            for var j = 0 ; j < lv1Node.COLLECTs.count ; j++
            {
                var lv2Node = lv1Node.COLLECTs[j]
                
                print("        Index:" + String(lv2Node.INDEX))
                print(" Name:" + lv2Node.C_ID)
                print(" PARENT:" + String(lv2Node.PARENT))
                print(" Prev:" + String(lv2Node.PREV))
                print(" Next:" + String(lv2Node.NEXT))
                print(String(format:" Ghost:%@" ,lv2Node.GHOST))
                print(String(format:" isVISITOR:%@" ,lv2Node.VISITOR))
                println()
                
                for var k = 0 ; k < lv2Node.COLLECTs.count ; k++
                {
                    var lv3Node = lv2Node.COLLECTs[k]
                    
                    print("            Index:" + String(lv3Node.INDEX))
                    print(" Name:" + lv3Node.C_ID)
                    print(" PARENT:" + String(lv3Node.PARENT))
                    print(" Prev:" + String(lv3Node.PREV))
                    print(" Next:" + String(lv3Node.NEXT))
                    print(String(format:" Ghost:%@" ,lv3Node.GHOST))
                    print(String(format:" isVISITOR:%@" ,lv3Node.VISITOR))
                    println()
                    
                }
            }
        }
    }
    
    func findNode(Node_ID Node:String) -> Collections
    {
        for var i = 0 ; i < Structure.count ; i++
        {
            if Structure[i].C_ID == Node
            {
                return Structure[i]
            }
        }
        return Structure[0]
    }
    
    func findNext(CurrentNode currentNode:String, PreviousNode prevNode:String) -> Collections
    {
        var cNode : Collections = findNode(Node_ID: currentNode)
        var pNode : Collections = findNode(Node_ID: prevNode)
        
        //現在位置 > 上一個位置 = 正向(true)
        var Forward : Bool = cNode.INDEX > pNode.INDEX ? false : true
        
        if cNode.INDEX == pNode.INDEX
        {
            Forward = false
        }
        
        //如果上一個點是GHOST,則清除所有群組內的GHOST
        if pNode.GHOST == true
        {
            LeaveNode(PreviousNode: pNode)
        }
        
        var Now : Collections = cNode
        var left : Collections!
        var right : Collections!
        
        if Now.NEXT < Structure.count
        {
            left = Structure[Now.NEXT]
        }
        else
        {
            left = Structure[0]
        }
        
        if Now.PREV < 0
        {
            right = Structure[Structure.count-1]
        }
        else
        {
            right = Structure[Now.PREV]
        }
        
        for var i = 0 ; i < Structure.count ; i++
        {
            //正向
            if Forward == true
            {
                if !right.VISITOR
                {
                    return Structure[right.INDEX]
                }
                else if !left.VISITOR
                {
                    return Structure[left.INDEX]
                }
            }
            else
            {
                if !left.VISITOR
                {
                    return Structure[left.INDEX]
                }
                else if !right.VISITOR
                {
                    return Structure[right.INDEX]
                }
            }
            //            right = Structure[right.NEXT]
            //            left = Structure[left.PREV]
            //
            if right.NEXT > Structure.count-1
            {
                right = Structure[0]
            }
            else
            {
                right = Structure[right.NEXT]
            }
            
            if left.PREV < 0
            {
                left = Structure[Structure.count-1]
            }
            else
            {
                left = Structure[left.PREV]
            }
        }
        
        return cNode
    }
    
    //如果離開的點是GHOST,則將所有群組內的GHOST都設定為 VISITOR = True
    func LeaveNode(PreviousNode pNode:Collections) -> [Collections]
    {
        var GhostGroup : [Collections] = []
        var cNode : Collections = pNode
        
        if !pNode.Root
        {
            if Structure[pNode.PARENT].GHOST == true
            {
                cNode = Structure[pNode.PARENT]
                
                for var i = 0 ; i < cNode.COLLECTs.count ; i++
                {
                    cNode.VISITOR = true
                    GhostGroup.append(cNode)
                }
            }
        }
        
        return GhostGroup
    }
    
    
}