//
//  RestaurantTableViewController.swift
//  orderApp
//
//  Created by chenqiming on 2020/4/29.
//  Copyright © 2020 chenqiming. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UITableViewController {

    //餐馆集合
    var restaurants:[Restaurant] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DAL.initDB()
        //DAL.showContentsOfDb()
        //从数据库中取餐馆数据
        restaurants = DAL.readRestaurants()
        
        //初始化订单数据库并将数据读入订单中,提前加载好订单内容
        //这样做的目的是无需等到点击订单页面之后才加载订单
        //得到订单页的controller
        let nav = tabBarController?.viewControllers?[1] as? UINavigationController
        let sec = nav?.viewControllers.first as? OrderedListTableViewController
        DAL.initOrderdDb()
        DAL.showContentsOfOrdered()
        sec?.orderedDishes = DAL.getOrdered()
        
        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurants.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = restaurants[indexPath.row].restName
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //为转场做准备，准备该餐厅的dishes数据
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //获取转场后的VC
        guard let dishesTableVC = segue.destination as? DishesTableViewController else {
            return
        }
        
        //将被选择餐馆对应的dishes数据传递过去
        if let indexPath = tableView.indexPathForSelectedRow {
            dishesTableVC.dishes
                = DAL.getDishesFromRest(restaurant: restaurants[indexPath.row])
        }
    }
    

}
