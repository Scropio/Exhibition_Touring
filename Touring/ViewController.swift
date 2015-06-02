//
//  ViewController.swift
//  Touring
//
//  Created by Neil on 2015/6/2.
//  Copyright (c) 2015年 Taiyuta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var exhibition:Exhibitions!
    var collectionArray:[Collections] = []
    
    var displayJson:[JSON] = []
    var previousDisplay = 0
    var currentDisplay = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let detailItem = NSURL(string: "http://104.199.133.111:3000/exhibitions?_id=552376d67320e1516264636b&render=all")
        request(.GET, detailItem!).responseJSON
            {(request, response, data, error) in
                if (data != nil) && (response?.statusCode == 200)
                {
                    let detailJson = JSON(data!)
                    
                    
                    self.exhibition = Exhibitions(JsonString: detailJson[0])
                    
                    //                    NSLog("%@", detailJson.string!)
                    
                    self.collectionArray = self.exhibition.FlatCollectionsArry
                    
                    for var i = 0 ; i < self.collectionArray.count ; i++
                    {
                        NSLog("%@  %@",self.collectionArray[i].C_ID ,self.collectionArray[i].C_NAME)
                    }
                }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

