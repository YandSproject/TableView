//
//  CellItem.swift
//  TableView
//
//  Created by YUMIKO HARAGUCHI on 2016/10/21.
//  Copyright © 2016年 YUMIKO HARAGUCHI. All rights reserved.
//

import UIKit

class CellItem: NSObject {
    var id : Int = 0
    var words : String = ""
    var name : String = ""
}

class CellItemService: NSObject {
    
    fileprivate var page : Int = 0
    fileprivate let PAGE_NUM : Int = 20
    
    fileprivate var sampleList: [[String: String]]? = [[:]]
    
    override init() {
        super.init()
        
        if let filePath: String = Bundle.main.path(forResource: "sample_list", ofType: "plist") {
            sampleList = NSArray(contentsOfFile: filePath) as? [[String : String]]
        }
        
    }
    
    ///cellに表示するアイテムを取得する
    func fetchItem(completed:@escaping (([CellItem]?)->Void)) {
        var items : [CellItem] = []

        
        DispatchQueue.global().async { [weak self] in
            if let weakSelf = self {
                let startNum : Int = (weakSelf.page * weakSelf.PAGE_NUM) + 1
                var endNum : Int = startNum + weakSelf.PAGE_NUM

                if startNum + weakSelf.PAGE_NUM >= weakSelf.sampleList?.count ?? 0 {
                    endNum = weakSelf.sampleList?.count ?? 0
                }
                
                if endNum < startNum {
                    DispatchQueue.main.async {
                        completed(items)
                    }
                    return
                }
                
                (startNum..<endNum).forEach { (i) in
                    if let data : [String: String] = weakSelf.sampleList?[i] {
                        let item : CellItem = CellItem()
                        item.id = i
                        item.words = data["words"] ?? "no data"
                        item.name = data["name"] ?? "no data"
                        items.append(item)
                    }
                }
                
                weakSelf.page += 1
            }

            DispatchQueue.main.async {
                completed(items)
            }
        }
    }
}
