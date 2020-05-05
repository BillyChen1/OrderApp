//
//  DishesTableViewController.swift
//  orderApp
//
//  Created by chenqiming on 2020/4/29.
//  Copyright © 2020 chenqiming. All rights reserved.
//

import UIKit

class DishesTableViewController: UITableViewController {

    //let exp = ["dish":"chicken", "price":"10"]
    var dishes:[Dish] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //将自定义cell注册到这个tablevc中
        let xib = UINib(nibName: "DishTableViewCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "cell2")
        tableView.rowHeight = 130
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dishes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! DishTableViewCell

        // Configure the cell...
        cell.DishNamelbl.text = dishes[indexPath.row].dishName
        cell.DishPricelbl.text = dishes[indexPath.row].price + "元"
        cell.imgView.image = dishes[indexPath.row].pic

        return cell
    }
    
    //实现点击自定义cell跳转到详情
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        //消息发送者是被选中的那一道菜
        let selectedDish = dishes[indexPath.row]
        self.performSegue(withIdentifier: "DetailDishView", sender: selectedDish)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //为详情页面准备被选中的dish数据
        guard let detailDishVC = segue.destination as? DetailDishViewController else {
            return
        }
        
        //将被选中的dish传过去
        detailDishVC.dish = sender as? Dish
    }
    

}
