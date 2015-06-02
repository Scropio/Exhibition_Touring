//
//  Exhibitions.swift
//  TouringDemo
//
//  Created by MacMini on 2015/5/23.
//  Copyright (c) 2015年 Taiyuta. All rights reserved.
//

import UIKit

class Exhibitions: NSObject {
    
    var ID      : String!
    var Title   : String!
    var TitleEn : String!
    
    var ID_Wheres  : NSMutableDictionary = NSMutableDictionary()
    var CollectionDict : NSMutableDictionary!
    
    //儲存所有的Root點(依展間)
    var CollectionArray : [Collections] = [Collections]()
    
    var FlatCollectionsArry : [Collections] = [Collections]()
    
    var ID_Collections : NSMutableDictionary = NSMutableDictionary()
    
    var Beacon_Collection : NSMutableDictionary = NSMutableDictionary()
    
    func printTree(RootCollection cCollection : Collections)
    {
        NSLog("----------------------------------------------------------")
        NSLog("ID:%@ Name:%15@ CHT:%15@ INDEX:%3d PARENT:%3d PREV:%3d NEXT:%3d Ghost:%@",
                cCollection.C_ID,
                cCollection.C_NAME,
                cCollection.C_NAME_CHT,
                cCollection.INDEX,
                cCollection.PARENT,
                cCollection.PREV,
                cCollection.NEXT,
                cCollection.GHOST.description)
        
        for var i = 0 ; i < cCollection.COLLECTs.count ; i++
        {
            var lv1Node = cCollection.COLLECTs[i]
            
            NSLog("2  ID:%@ Name:%15@ CHT:%15@ INDEX:%3d PARENT:%3d PREV:%3d NEXT:%3d Ghost:%@",
                lv1Node.C_ID,
                lv1Node.C_NAME,
                lv1Node.C_NAME_CHT,
                lv1Node.INDEX,
                lv1Node.PARENT,
                lv1Node.PREV,
                lv1Node.NEXT,
                lv1Node.GHOST.description)
            
            for var j = 0 ; j < lv1Node.COLLECTs.count ; j++
            {
                var lv2Node = lv1Node.COLLECTs[j]
                
                NSLog("3    ID:%@ Name:%15@ CHT:%15@ INDEX:%3d PARENT:%3d PREV:%3d NEXT:%3d Ghost:%@",
                    lv2Node.C_ID,
                    lv2Node.C_NAME,
                    lv2Node.C_NAME_CHT,
                    lv2Node.INDEX,
                    lv2Node.PARENT,
                    lv2Node.PREV,
                    lv2Node.NEXT,
                    lv2Node.GHOST.description)
                
                for var k = 0 ; k < lv2Node.COLLECTs.count ; k++
                {
                    var lv3Node = lv2Node.COLLECTs[k]
                    
                    NSLog("4      ID:%@ Name:%15@ CHT:%15@ INDEX:%3d PARENT:%3d PREV:%3d NEXT:%3d Ghost:%@",
                        lv3Node.C_ID,
                        lv3Node.C_NAME,
                        lv3Node.C_NAME_CHT,
                        lv3Node.INDEX,
                        lv3Node.PARENT,
                        lv3Node.PREV,
                        lv3Node.NEXT,
                        lv3Node.GHOST.description)
                }
                
            }
        }
    }
    
    init(JsonString Json:JSON)
    {
        super.init()
        
        self.ID = Json["_id"].string
        self.Title = Json["title"]["text_cht"].string
        
        println("ID:" + self.ID)
        println("Title:" + self.Title)
        println("ID_Wheres.count:" + String(ID_Wheres.count))
        println("CollectionsArray.count:" + String(CollectionArray.count))
    
        var cIndex : Int = 0
        
        var cRoot : Collections!
        
        var Lv1Json = Json["collections"][0]["collections"]

        var TreeList = NSMutableDictionary()
        var TreeID : Int = 0
        
        for var i = 0 ; i < Lv1Json.count ; i++
        {
            if Lv1Json[i]["where"][0]["_id"] != nil
            {
                let cTree : String = Lv1Json[i]["where"][0]["_id"].string!
                
                if TreeList[cTree] == nil
                {
                    TreeList.setValue(TreeID++, forKey: cTree)
                }
            }
        }
        
        for var t = 0 ; t < TreeID ; t++
        {
            cRoot = Collections(Json: Json["collections"][0],
                                Parent: -1,
                                Index: cIndex,
                                isRoot: true)
            
            FlatCollectionsArry.append(cRoot)
            ID_Collections.setValue(cRoot, forKey: cRoot.C_ID)
            ID_Wheres.setValue(t, forKey: cRoot.C_ID)
            
            for var i = 0 ; i < Lv1Json.count ; i++
            {

                var Lv1Node = Collections(Json: Lv1Json[i],
                                          Parent: cRoot.INDEX,
                                          Index: ++cIndex,
                                          isRoot: false)
                
                cRoot.COLLECTs.append(Lv1Node)
                
                if cRoot.BEACONs.count > 0
                {
                    for var b = 0 ; b < Lv1Node.BEACONs.count ; b++
                    {
                        Beacon_Collection.setValue(cRoot.C_ID, forKey: cRoot.BEACONs[b].UUID)
                    }
                }
                
                cRoot.Structure.append(Lv1Node)
                FlatCollectionsArry.append(Lv1Node)
                ID_Collections.setValue(Lv1Node, forKey: Lv1Node.C_ID)
                ID_Wheres.setValue(t, forKey: Lv1Node.C_ID)
                
                var Lv2Json = Lv1Json[i]["collections"]
                
                for var j = 0 ; j < Lv2Json.count ; j++
                {
                    var Lv2Node = Collections(Json: Lv2Json[j],
                                              Parent: Lv1Node.INDEX,
                                              Index: ++cIndex,
                                              isRoot: false)
                    
                    Lv1Node.COLLECTs.append(Lv2Node)
                    
                    if Lv2Node.BEACONs.count > 0
                    {
                        for var b = 0 ; b < Lv2Node.BEACONs.count ; b++
                        {
                            Beacon_Collection.setValue(Lv2Node.C_ID, forKey: Lv2Node.BEACONs[b].UUID)
                        }
                    }
                    
                    cRoot.Structure.append(Lv2Node)
                    FlatCollectionsArry.append(Lv2Node)
                    ID_Collections.setValue(Lv2Node, forKey: Lv2Node.C_ID)
                    ID_Wheres.setValue(t, forKey: Lv2Node.C_ID)
                    
                    var Lv3Json = Lv2Json[j]["collections"]
                    
                    for var k = 0 ; k < Lv3Json.count ; k++
                    {
                        var Lv3Node = Collections(Json: Lv3Json[k],
                                                  Parent: Lv2Node.INDEX,
                                                  Index: ++cIndex,
                                                  isRoot: false)
                        
                        Lv2Node.COLLECTs.append(Lv3Node)
                        
                        if Lv3Node.BEACONs.count > 0
                        {
                            for var b = 0 ; b < Lv1Node.BEACONs.count ; b++
                            {
                                Beacon_Collection.setValue(Lv3Node.C_ID, forKey: Lv3Node.BEACONs[b].UUID)
                            }
                        }
                        
                        cRoot.Structure.append(Lv3Node)
                        FlatCollectionsArry.append(Lv3Node)
                        ID_Collections.setValue(Lv3Node, forKey: Lv3Node.C_ID)
                        ID_Wheres.setValue(t, forKey: Lv3Node.C_ID)
                    }
                }
            }
            
            cRoot.Structure[0].PREV = cRoot.Structure.count-1
            cRoot.Structure[cRoot.Structure.count-1].NEXT = 1
            cRoot.Structure[1].PREV = cRoot.Structure.count-1
            
            CollectionArray.append(cRoot)
        }
        
        self.printTree(RootCollection: cRoot)
        
        for var g = 0 ; g < FlatCollectionsArry.count ; g++
        {
            println(String(format:"Flat[%d]=%@",g,FlatCollectionsArry[g].C_NAME))
        }

        
        
        
        
        
        /*
        //Generate Root Node
        for var w = 0; w < Json[0]["where"].count ; w++
        {
            var cIndex = 0
            var where_uuid : String = Json[0]["where"][w]["_id"].string!
            var rCollections : Collections = Collections(ID: self.ID, Parent: -1, Index:cIndex, isRoot: true)
            rCollections.PREV = cIndex-1
            rCollections.NEXT = cIndex+1
            rCollections.C_NAME_CHT = Json[0]["where"][w]["name"].string
            rCollections.C_NAME = Json[0]["where"][w]["name"].string
            rCollections.C_JSON = Json[0]
            
            print("Name:" + rCollections.C_NAME)
            print(" NameCHT:" + rCollections.C_NAME_CHT)
            print(" Index:" + String(rCollections.INDEX))
            print(" Prev:" + String(rCollections.PREV))
            print(" Next:" + String(rCollections.NEXT))
            println()
            
            var RootJson : JSON = Json[0]["collections"]
            var RootParent : Int = cIndex
            
            if w == 0
            {
                FlatCollectionsArry.append(rCollections)
            }
            rCollections.Structure.append(rCollections)
            
            NSLog("RootJSON.count:%d",RootJson.count)
            
            //Generate Lv1 Node
            for var i = 0 ; i < RootJson.count ; i++
            {
                //Json[0]["collections"][i]
                var Lv1Json : JSON = RootJson[i]
                var Lv1Parent : Int = cIndex
                
                if Lv1Json["where"].count > 0
                {
                    if Lv1Json["where"][0]["_id"].string! == where_uuid
                    {
                        var Lv1Node = Collections(ID: Lv1Json["_id"].string!, Parent: RootParent, Index: ++cIndex, isRoot: false)
                        
                        setNodeProperty(CollectionNode: Lv1Node, Index: cIndex,Level:1 ,JsonString: Lv1Json)
                        
                        rCollections.COLLECTs.append(Lv1Node)
                        rCollections.Structure.append(Lv1Node)
                        FlatCollectionsArry.append(Lv1Node)
                        ID_Wheres.setValue(w, forKey: Lv1Node.C_ID)
                        ID_Collections.setValue(Lv1Node, forKey: Lv1Node.C_ID)
                        
                        if Lv1Json[i]["ibeacons"].count > 0
                        {
                            Beacon_Collection.setValue(Lv1Json[i]["_id"].string!, forKey:Lv1Node.BEACONs.UUID )
                        }
                        
                        
                        //Json[0]["collections"][i]["collections"]
                        var Lv2Json : JSON = Lv1Json["collections"]
                        var Lv2Parent : Int = cIndex
                        
                        //Generate Lv2 Node
                        for var j = 0 ; j < Lv2Json.count ; j++
                        {
                            var Lv2Node = Collections(ID: Lv2Json[j]["_id"].string!, Parent: Lv2Parent, Index: ++cIndex, isRoot: false)
                            
                            setNodeProperty(CollectionNode: Lv2Node, Index: cIndex,Level:2 ,JsonString: Lv2Json[j])
                            
                            rCollections.COLLECTs[i].COLLECTs.append(Lv2Node)
                            rCollections.Structure.append(Lv2Node)
                            FlatCollectionsArry.append(Lv2Node)
                            ID_Wheres.setValue(w, forKey: Lv2Node.C_ID)
                            ID_Collections.setValue(Lv2Node, forKey: Lv2Node.C_ID)
                            
                            if Lv2Json[j]["ibeacons"].count > 0
                            {
                                Beacon_Collection.setValue(Lv2Json[j]["_id"].string!, forKey:Lv2Node.BEACONs.UUID )
                            }
                            
                            var Lv3Json : JSON = Lv2Json[j]["collections"]
                            var Lv3Parent : Int = cIndex
                            
                            //Generate Lv3 Node
                            for var k = 0 ; k < Lv3Json.count ; k++
                            {
                                var Lv3Node = Collections(ID: Lv3Json[k]["_id"].string!, Parent: Lv3Parent, Index: ++cIndex, isRoot: false)
                                
                                setNodeProperty(CollectionNode: Lv3Node, Index: cIndex,Level:3,JsonString: Lv3Json[k])
                                
                                rCollections.COLLECTs[i].COLLECTs[j].COLLECTs.append(Lv3Node)
                                rCollections.Structure.append(Lv3Node)
                                FlatCollectionsArry.append(Lv3Node)
                                ID_Wheres.setValue(w, forKey: Lv3Node.C_ID)
                                ID_Collections.setValue(Lv3Node, forKey: Lv3Node.C_ID)
                                
                                if Lv3Json[k]["ibeacons"].count > 0
                                {
                                    Beacon_Collection.setValue(Lv3Json[k]["_id"].string!, forKey:Lv3Node.BEACONs.UUID )
                                }
                            }
                        }
                    }
                }
            }
            
            println("Beacon_Collection.count:" + String(Beacon_Collection.count))
            
            rCollections.printStructure()
            
            if rCollections.Structure.count > 1
            {
                rCollections.Structure[0].PREV = rCollections.Structure.count-1
                rCollections.Structure[rCollections.Structure.count-1].NEXT = 1
                rCollections.Structure[1].PREV = rCollections.Structure.count-1
            }
            
            CollectionArray.append(rCollections)
            
            println()
        }
        
        for var g = 0 ; g < FlatCollectionsArry.count ; g++
        {
            println(String(format:"Flat[%d]=%@",g,FlatCollectionsArry[g].C_NAME))
        }
        
        println("EXHIBITION.BEACON.count:" + String(self.Beacon_Collection.count))
        
        for var t = 0 ; t < CollectionArray.count ; t++
        {
            println("Structure: " + String(t))
            for var i = 0 ; i < CollectionArray[t].COLLECTs.count ; i++
            {
                print("    Structure[" + String(t) + "]")
                print("[" + String(i) + "]")
                print(" Name:" + CollectionArray[t].COLLECTs[i].C_NAME)
                println()
                
                for var j = 0 ; j < CollectionArray[t].COLLECTs[i].COLLECTs.count ; j++
                {
                    print("        Structure[" + String(t) + "]")
                    print("[" + String(i) + "]")
                    print("[" + String(j) + "]")
                    print(" Name:" + CollectionArray[t].COLLECTs[i].COLLECTs[j].C_NAME)
                    println()
                    
                    for var k = 0 ; k < CollectionArray[t].COLLECTs[i].COLLECTs[j].COLLECTs.count ; k++
                    {
                        print("            Structure[" + String(t) + "]")
                        print("[" + String(i) + "]")
                        print("[" + String(j) + "]")
                        print("[" + String(k) + "]")
                        print(" Name:" + CollectionArray[t].COLLECTs[i].COLLECTs[j].COLLECTs[k].C_NAME)
                        println()
                    }
                }
            }
        }
        */
    }
    
    func BuildTree(Collection pCollection : Collections , Json json : JSON ) -> Collections
    {
        var cCollection : Collections = Collections(Json: json,
                                                    Parent: pCollection.INDEX,
                                                    Index: pCollection.INDEX+1,
                                                    isRoot: false)
        NSLog("NAME:%@",cCollection.C_ID)
        
        for var i = 0 ; i < json["collections"].count ; i++
        {
            cCollection.COLLECTs.append(BuildTree(Collection: cCollection, Json: json["collections"][i]))
        }
        
        pCollection.COLLECTs.append(cCollection)
    
        return pCollection
    }
    
    private var RecommandList : [Collections] = [Collections]()
    private var HistoryList   : [Collections] = [Collections]()
    private var PreParentList : [Collections] = [Collections]()
    
    //    func ChangePosition(Collection Node : Collections)
    //    {
    //        var StructureID : Int = FindStructure(NodeID: Node.C_ID)
    //        var cRoot : Collections = self.CollectionArray[StructureID]
    //        var cNode : Collections = cRoot.FindCollections(NodeID: Node.C_ID)
    //
    //        var pPath : Collections = Collections(ID: "Recommand", Parent: -1)
    //
    //        var nextNode : Collections!
    //        var prevNode : Collections!
    //        var parNode : Collections!
    //    }
    
    func FindStructure(NodeID NodeUUID:String) -> Int
    {
        return ID_Wheres.valueForKey(NodeUUID) as! Int
    }
    
    func printTree(Collection cCollection : Collections, Level _level : Int)
    {
        var Space : String = ""
        
        for var i = 0 ; i < _level ; i++
        {
            Space += " "
        }
        
        for var i = 0 ; i < cCollection.COLLECTs.count ; i++
        {
            printTree(Collection: cCollection.COLLECTs[i], Level: _level+1)
        }
    }
    
//    func setNodeProperty(CollectionNode Node:Collections , Index index:Int, Level Lv:Int,JsonString Json:JSON) -> Collections
//    {
//        Node.C_ID       = Json["_id"].string
//        
//        if Json["name"].count > 0
//        {
//            Node.C_NAME     = Json["name"]["text"].string
//            Node.C_NAME_CHT = Json["name"]["text_cht"].string
//        }
//        else
//        {
//            Node.C_NAME = "  "
//            Node.C_NAME_CHT = "  "
//        }
//        
//        Node.C_COVER_ID = Json["general_information"]["cover_photo"]["_id"].string
//        
//        Node.PREV = index-1
//        Node.NEXT = index+1
//        
//        var Space : String = ""
//        for var i = 0 ; i < Lv * 4 ; i++
//        {
//            Space += " "
//        }
//        //TODO
//        Node.C_JSON = Json
//        
//        if Json["ghost"].bool != nil
//        {
//            Node.GHOST = Json["ghost"].bool
//        }
//       
//        if Json["ibeacons"].count > 0
//        {
//            var cBeacon = Beacons(Major_Minor: Json["ibeacons"][0]["uuid"].string!,
//                                  RSSI : Json["ibeacons"][0]["rssi"].int!)
//            
//            Node.BEACONs = cBeacon
//            println(String(format:"Node: %@ Beacon:%@",Node.C_NAME,Node.BEACONs.UUID))
//            
//            Beacon_Collection.setValue(Node.C_ID, forKey: Node.BEACONs.UUID)
//        }
    

        
        //        println(String(format:"JSON:%@",Json[0].string!))
        //
        //        if Json["ghost"].count > 0
        //        {
        //            println(String(format:"GHOST:%@",Json["ghost"].string!))
        //            if Json["ghost"].string == "1"
        //            {
        //                Node.GHOST = true
        //            }
        //            else
        //            {
        //                Node.GHOST = false
        //            }
        //        }
        //        else
        //        {
        //            println("No Ghost")
        //        }
        
        
        //        print("ID:" + Node.C_ID)
        //        print(Space)
        //        print(" Name:" + Node.C_NAME)
        //        print(" NameCHT:" + Node.C_NAME_CHT)
        //        print(" Index:" + String(Node.INDEX))
        //        print(" Prev:" + String(Node.PREV))
        //        print(" Next:" + String(Node.NEXT))
        //        println()
        
//        return Node
//    }
    
    func setAllRootVisitor()
    {
        for var i = 0 ; i < CollectionArray.count ; i++
        {
            self.CollectionArray[i].VISITOR = true
        }
    }
    
    func checkAllVisitor(RootNode Root:Collections) -> Bool
    {
        var isAllVisitor : Bool = false
        
        //        for var i = 0 ; i < CollectionArray
        
        return isAllVisitor
    }
    
    func CreatTree(JSON Json:JSON)
    {
        var currentJson = Json[0]["Collections"]
    }
    
    //如果離開的點是GHOST,則將所有群組內的GHOST都設定為 VISITOR = True
    //    func LeaveNode(PreviousNode pNode:Collections)
    //    {
    //        var cNode : Collections = pNode
    //        
    //        if Structure[pNode.PARENT].GHOST == true
    //        {
    //            cNode = Structure[pNode.PARENT]
    //            
    //            for var i = 0 ; i < cNode.COLLECTs.count ; i++
    //            {
    //                if cNode.GHOST == true
    //                {
    //                    cNode.VISITOR = true
    //                }
    //            }
    //        }
    //    }
    
}
