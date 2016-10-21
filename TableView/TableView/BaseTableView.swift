//
//  BaseTableView.swift
//  TableView
//
//  Created by YUMIKO HARAGUCHI on 2016/10/21.
//  Copyright © 2016年 YUMIKO HARAGUCHI. All rights reserved.
//

import UIKit

protocol BaseTableViewDelegate: class {
    func selectedCell(item: CellItem, atIndexPath: IndexPath)
    func fetchNewData()
}

class BaseTableView: UITableView {

    var itemList : [CellItem] = []
    weak var baseDelegate : BaseTableViewDelegate?
    
    fileprivate let CELLNAME : String = "TableViewCell"
    fileprivate let DEFAULT_HEIGHT : CGFloat = 60.0
    
    fileprivate var isInsertEnd : Bool = false
    fileprivate var heights: [IndexPath : CGFloat] = [:]

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()

    }
    
    override func awakeFromNib() {
        self.initialize()

    }
    
    func setupItem(list : [CellItem]?) {
        if let l : [CellItem] = list {
            itemList = l
            self.reloadData()

        }
        
    }
    
    func insertItem(list: [CellItem]?) {
        
        if list == nil || list!.count == 0 {
            isInsertEnd = true
            return
        }
        
        let startNum :Int = itemList.count
        let contentsNum : Int = list!.count + startNum

        var indexPathes : [IndexPath] = []
        (startNum..<contentsNum).forEach { (i) in
            let indexPath : IndexPath = IndexPath(row: i, section: 0)
            indexPathes.append(indexPath)
        }
        
        itemList.append(contentsOf: list!)
        
        self.beginUpdates()
        
        self.insertRows(at: indexPathes, with: UITableViewRowAnimation.fade)
        
        self.endUpdates()
    }
    
}

extension BaseTableView {
    fileprivate func initialize() {
        self.delegate = self
        self.dataSource = self
        
        self.estimatedRowHeight = DEFAULT_HEIGHT
        self.rowHeight = UITableViewAutomaticDimension
        
        let nib : UINib = UINib(nibName: CELLNAME, bundle: nil)
        self.register(nib, forCellReuseIdentifier: CELLNAME)
        
        self.tableFooterView = UIView()
    }
}


extension BaseTableView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TableViewCell = self.dequeueReusableCell(withIdentifier: CELLNAME, for: indexPath) as! TableViewCell
        cell.setupCell(cellitem: itemList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.deselectRow(at: indexPath, animated: true)
        baseDelegate?.selectedCell(item: itemList[indexPath.row], atIndexPath: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if heights[indexPath] == nil {
            cell.contentView.updateConstraints()
            heights[indexPath] = cell.frame.size.height
        }
        
        if itemList.count == 0 || isInsertEnd == true {
            return
        }
        
        if itemList.count - 1 == indexPath.row {
            baseDelegate?.fetchNewData()
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return heights[indexPath] ?? DEFAULT_HEIGHT
    }
}
