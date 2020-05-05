//
//  DAL.swift
//  orderApp
//
//  Created by chenqiming on 2020/5/1.
//  Copyright © 2020 chenqiming. All rights reserved.
//

import Foundation

import UIKit

class DAL {
    //初始化菜品-餐馆表和菜品表
    static func initDB() {
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB() {return}
        
        //建表 菜品id-餐馆id-餐馆名字
        //三家餐馆 kfc有两道菜 农家乐有d三道菜 西餐厅有两道菜
        let createsql = "CREATE TABLE IF NOT EXISTS dish_rest('dishID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"+"'restID' INTEGER, 'restName' TEXT);"
        if !sqlite.execNoneQuerySQL(sql: createsql) {
            sqlite.closeDB()
            return
        }
        //插入数据
        let dr1 = "INSERT OR REPLACE INTO dish_rest(dishID, restID, restName) VALUES(1, 1, 'kfc');"
        let dr2 = "INSERT OR REPLACE INTO dish_rest(dishID, restID, restName) VALUES(2, 1, 'kfc');"
        let dr3 = "INSERT OR REPLACE INTO dish_rest(dishID, restID, restName) VALUES(3, 2, '农家乐');"
        let dr4 = "INSERT OR REPLACE INTO dish_rest(dishID, restID, restName) VALUES(4, 2, '农家乐');"
        let dr5 = "INSERT OR REPLACE INTO dish_rest(dishID, restID, restName) VALUES(5, 2, '农家乐');"
        let dr6 = "INSERT OR REPLACE INTO dish_rest(dishID, restID, restName) VALUES(6, 3, '西餐厅');"
        let dr7 = "INSERT OR REPLACE INTO dish_rest(dishID, restID, restName) VALUES(7, 3, '西餐厅');"
        
        if !sqlite.execNoneQuerySQL(sql: dr1) {sqlite.closeDB();return}
        if !sqlite.execNoneQuerySQL(sql: dr2) {sqlite.closeDB();return}
        if !sqlite.execNoneQuerySQL(sql: dr3) {sqlite.closeDB();return}
        if !sqlite.execNoneQuerySQL(sql: dr4) {sqlite.closeDB();return}
        if !sqlite.execNoneQuerySQL(sql: dr5) {sqlite.closeDB();return}
        if !sqlite.execNoneQuerySQL(sql: dr6) {sqlite.closeDB();return}
        if !sqlite.execNoneQuerySQL(sql: dr7) {sqlite.closeDB();return}
     
       /*********************/
        
        //建立菜品表 菜品id-菜名称-单价-介绍
        let createDishsql = "CREATE TABLE IF NOT EXISTS dish('dishID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"+"'dishName' TEXT, 'price' DOUBLE, 'detail' TEXT, 'pic' BLOB);"
        if !sqlite.execNoneQuerySQL(sql: createDishsql) {
            sqlite.closeDB()
            return
        }
        //插入数据（不包含图片）
        let d1 = "INSERT OR REPLACE INTO dish(dishID, dishName, price, detail) VALUES(1, '汉堡', 15, '麻辣鸡腿堡，点燃你夏天的热情！');"
        let d2 = "INSERT OR REPLACE INTO dish(dishID, dishName, price, detail) VALUES(2, '蛋挞', 4, '香醇可口的原味葡式蛋挞');"
        let d3 = "INSERT OR REPLACE INTO dish(dishID, dishName, price, detail) VALUES(3, '糖醋排骨', 35, '美味的糖醋排骨');"
        let d4 = "INSERT OR REPLACE INTO dish(dishID, dishName, price, detail) VALUES(4, '番茄炒鸡蛋', 15, '家常小炒，番茄炒鸡蛋');"
        let d5 = "INSERT OR REPLACE INTO dish(dishID, dishName, price, detail) VALUES(5, '可乐鸡翅', 25, '咸中带甜的可乐鸡翅');"
        let d6 = "INSERT OR REPLACE INTO dish(dishID, dishName, price, detail) VALUES(6, '牛排', 50, '口感细腻的嫩牛排，满足你的味觉');"
        let d7 = "INSERT OR REPLACE INTO dish(dishID, dishName, price, detail) VALUES(7, '披萨', 40, '美味的海鲜披萨');"
        if !sqlite.execNoneQuerySQL(sql: d1) {sqlite.closeDB();return}
        if !sqlite.execNoneQuerySQL(sql: d2) {sqlite.closeDB();return}
        if !sqlite.execNoneQuerySQL(sql: d3) {sqlite.closeDB();return}
        if !sqlite.execNoneQuerySQL(sql: d4) {sqlite.closeDB();return}
        if !sqlite.execNoneQuerySQL(sql: d5) {sqlite.closeDB();return}
        if !sqlite.execNoneQuerySQL(sql: d6) {sqlite.closeDB();return}
        if !sqlite.execNoneQuerySQL(sql: d7) {sqlite.closeDB();return}
        
        /******************/
        
        //插入图片
        let pics = ["hamburger","eggtart","tangcupaigu","fanqiechaojidan","kelejichi","steak","pizza"]
        for i in 1...7 {
            let image = UIImage(named: pics[i-1])
            SaveImage(id: i, img: image)
        }
        
        sqlite.closeDB()
    }
    
    //初始化订单表
    static func initOrderdDb() {
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB() {return}
        
        //建订单表 订单id-菜品id-价格
        let createsql = "CREATE TABLE IF NOT EXISTS ordered('orderID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"+"'dishID' INTEGER, 'price' DOUBLE);"
        if !sqlite.execNoneQuerySQL(sql: createsql) {
            sqlite.closeDB()
            return
        }
    }
    
    
    static func SaveImage(id:Int, img:UIImage?) {
        if img == nil {return}
        
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB() {return}
        
        let sql = "UPDATE dish SET pic = ? WHERE dishID = \(id)"
        let data = img!.jpegData(compressionQuality: 1.0) as NSData?
        sqlite.execSaveBlob(sql: sql, blob: data!)
        
        sqlite.closeDB()
        return
    }
    
    //根据菜品名字获取对应图片
    static func LoadImage(dishName:String) -> UIImage {
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB() {return UIImage(named: "nopic")!}
        
        let sql = "SELECT pic FROM dish where dishName = '\(dishName)'"
        let data = sqlite.execLoadBlob(sql: sql)
        sqlite.closeDB()
        
        if data != nil {
            return UIImage(data: data!)!
        } else {
            return UIImage(named: "nopic")!
        }
    }
    
    static func showContentsOfDb() {
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB() {return}
        
        let query1 = sqlite.execQuerySQL(sql: "SELECT * FROM dish_rest")
        let query2 = sqlite.execQuerySQL(sql: "SELECT * FROM dish")
        print(query1!)
        print(query2!)
        sqlite.closeDB()
    }
    
    static func showContentsOfOrdered() {
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB() {return}
        
        let query = sqlite.execQuerySQL(sql: "SELECT * FROM ordered")
        print(query!)
        sqlite.closeDB()
    }
    
    
    //从数据库中读取出餐馆信息
    static func readRestaurants() -> [Restaurant] {
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB() {return []}
        
        let queryResult = sqlite.execQuerySQL(sql: "SELECT DISTINCT restID, restName FROM dish_rest")
        //打印所有餐馆信息
        //print(queryResult as Any)
        
        var restaurants:[Restaurant] = []
        
        //将查询结果的每一行记录转化为Restaurant对象存入餐馆数组
        for record in queryResult! {
            let restID_int = record["restID"] as? Int
            let restID:String = "\(restID_int ?? 0)"
            let restName = record["restName"] as? String
            let restaurant = Restaurant(restID: restID, restName: restName!)
            restaurants.append(restaurant)
        }
        
        sqlite.closeDB()
        return restaurants
    }
    
    //根据某一个餐馆获得所有菜品
    static func getDishesFromRest(restaurant:Restaurant) -> [Dish] {
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB() {return []}
        
        
        let restID = restaurant.restID
        let sql = "SELECT dish.dishID, dishName, price, detail FROM dish_rest, dish WHERE restID = \(restID) AND dish_rest.dishID = dish.dishID"
        let res = sqlite.execQuerySQL(sql: sql)
        
        //输出选择结果
        //print(res as Any)
        
        var dishes:[Dish] = []
        
        //将除了图片以外的数据读入数组
        for record in res! {
            let dishID_int = record["dishID"] as? Int
            let dishID = "\(dishID_int ?? 0)"
            let dishName = record["dishName"] as! String
            let price_double = record["price"] as? Double
            let price = "\(price_double ?? 0.0)"
            let detail = record["detail"] as! String
            
            var dish = Dish(dishID: dishID, dishName: dishName, price: price, detail: detail)
            
            dishes.append(dish)
        }
        
        //图片读入数组
        for i in 0..<dishes.count {
            dishes[i].pic = LoadImage(dishName: dishes[i].dishName)
        }
        
        sqlite.closeDB()
        return dishes
    }
    
    //从数据库的订单表中获取所有订单信息
    static func getOrdered() -> [Dish] {
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB() {return []}
        
        let qRes = sqlite.execQuerySQL(sql: "SELECT * FROM ordered")
        
        var orderedDished:[Dish] = []
        
        if let res = qRes {     //第一次执行时查询结果一定为空，该方法将返回空数组
            for record in res {
                //根据订单表中的dishID项，从菜品表中取出这道菜
                let dishID_int = record["dishID"] as! Int
                let dishID = "\(dishID_int)"
                let theDish = sqlite.execQuerySQL(sql: "SELECT * FROM dish WHERE dishID = \(dishID_int)")
                
                let dishName = theDish![0]["dishName"] as! String
                let price_double = theDish![0]["price"] as? Double
                let price = "\(price_double ?? 0.0)"
                let detail = theDish![0]["detail"] as! String
                    
                let dish = Dish(dishID: dishID, dishName: dishName, price: price, detail: detail)
                orderedDished.append(dish)
            }
            sqlite.closeDB()
            return orderedDished
        } else {
            sqlite.closeDB()
            return []
        }
    }
    
    //将订单写入数据库
    static func saveOrdered(orderedDishes:[Dish]) {
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB() {return}
        
        //先清空表中所有记录
        if !sqlite.execNoneQuerySQL(sql: "DELETE FROM ordered") {
            print("执行删除语句错误")
            sqlite.closeDB()
            return
        }
        
        var i = 1
        for dish in orderedDishes {
            let dishID = Int(dish.dishID)
            let dishPrice = Double(dish.price)!
            
            let sql = "INSERT OR REPLACE INTO ordered(orderID, dishID, price) VALUES(\(i), \(dishID!), \(dishPrice));"
            if !sqlite.execNoneQuerySQL(sql: sql) {
                print("执行\(sql)失败")
                sqlite.closeDB()
                return
            }
            i += 1
        }
        
        sqlite.closeDB()
        return
    }
    
}

