//
//  DetailDishViewController.swift
//  orderApp
//
//  Created by chenqiming on 2020/5/2.
//  Copyright © 2020 chenqiming. All rights reserved.
//

import UIKit

class DetailDishViewController: UIViewController {

    var dish : Dish?
    var addItemDelegate:AddItemDelegate?
    
    @IBOutlet weak var dishImg: UIImageView!
    
    
    @IBOutlet weak var dishNameLbl: UILabel!
    
    
    @IBOutlet weak var priceLbl: UILabel!
    
    
    @IBOutlet weak var detailLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //展示菜品详细信息
        dishImg.image = dish?.pic
        dishNameLbl.text = dish?.dishName
        priceLbl.text = dish!.price + "元"
        detailLbl.text = dish?.detail
        
        //得到订单页的controller
        let nav = tabBarController?.viewControllers?[1] as? UINavigationController
        let sec = nav?.viewControllers.first as? OrderedListTableViewController
        addItemDelegate = sec
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func addBtnTapped(_ sender: Any) {
        addItemDelegate?.addItem(dish: dish!)
    }
    
}
