//
//  Restaurant.swift
//  orderApp
//
//  Created by chenqiming on 2020/5/1.
//  Copyright © 2020 chenqiming. All rights reserved.
//

import Foundation

class Restaurant : NSObject, Codable{
    var restID:String = ""
    var restName:String = ""
    
    init(restID:String, restName:String) {
        self.restID = restID
        self.restName = restName
    }
    
    override var description:String {
        return "restID:\(restID), restName:\(restName)"
    }
    
    
}
