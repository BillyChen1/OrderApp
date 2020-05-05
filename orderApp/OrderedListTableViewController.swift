//
//  OrderedListTableViewController.swift
//  orderApp
//
//  Created by chenqiming on 2020/4/29.
//  Copyright © 2020 chenqiming. All rights reserved.
//

import UIKit

//添加新项目的接口
protocol AddItemDelegate {
    func addItem(dish:Dish)
}



class OrderedListTableViewController: UITableViewController, AddItemDelegate {

    var orderedDishes:[Dish] = []
    
    func addItem(dish: Dish) {
           orderedDishes.append(dish)
           //下侧tab更新数目
           navigationController?.tabBarItem.badgeValue = "\(orderedDishes.count)"
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //从数据库获取订单信息
        //DAL.initOrderdDb()
        //DAL.showContentsOfOrdered()
        //orderedDishes = DAL.getOrdered()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orderedDishes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = orderedDishes[indexPath.row].dishName
        cell.detailTextLabel?.text = orderedDishes[indexPath.row].price
        
        return cell
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //删除记录
        if editingStyle == .delete {
            // Delete the row from the data source
            orderedDishes.remove(at: indexPath.row)
            //删除记录时同时也更新数据库
            //而不是等到点击提交后再更新数据库
            DAL.saveOrdered(orderedDishes: orderedDishes)
            //下方数目更新
            navigationController?.tabBarItem.badgeValue = "\(orderedDishes.count)"
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        let p = UIAlertController(title: "确定提交订单？", message: nil, preferredStyle: .alert)
        p.addAction(UIAlertAction(title: "确定", style: .default, handler: {
            action in
            //提交确定点击后，先把订单写入数据库
            if self.orderedDishes.count > 0 {
                DAL.saveOrdered(orderedDishes: self.orderedDishes)
                //展示成功页面
                let thanksVC = ThanksViewController()
                self.present(thanksVC, animated: true, completion: nil)
            } else {
                print("当前无菜品可以提交")
            }
        }))
        
        
        p.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(p, animated: false, completion: nil)
    }
    
}

