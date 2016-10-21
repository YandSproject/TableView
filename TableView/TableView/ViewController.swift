//
//  ViewController.swift
//  TableView
//
//  Created by YUMIKO HARAGUCHI on 2016/10/21.
//  Copyright © 2016年 YUMIKO HARAGUCHI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: BaseTableView!
    
    let service : CellItemService = CellItemService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }

    func setup() {
        tableView.baseDelegate = self
        
        service.fetchItem {[weak self] (list) in
            if let weakSelf = self {
                weakSelf.tableView.setupItem(list: list)

            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


extension ViewController : BaseTableViewDelegate {
    
    func selectedCell(item: CellItem, atIndexPath: IndexPath) {
        
    }
    
    func fetchNewData() {
        service.fetchItem { [weak self] (list) in
            if let weakSelf = self {
                weakSelf.tableView.insertItem(list: list)
            }
        }

    }
}
