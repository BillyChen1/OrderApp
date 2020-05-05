//
//  Dish.swift
//  orderApp
//
//  Created by chenqiming on 2020/5/1.
//  Copyright © 2020 chenqiming. All rights reserved.
//

import Foundation
import UIKit

class Dish : NSObject {
    var dishID:String = ""
    var dishName:String = ""
    var price:String = ""
    var detail:String = ""
    var pic:UIImage?
    
    init(dishID:String, dishName:String, price:String, detail:String) {
        self.dishID = dishID
        self.dishName = dishName
        self.price = price
        self.detail = detail
    }
    
    override var description: String {
        return "dishID:\(dishID), dishName:\(dishName), price:\(price), detail:\(detail)"
    }
    
}
