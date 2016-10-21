//
//  TableViewCell.swift
//  TableView
//
//  Created by YUMIKO HARAGUCHI on 2016/10/21.
//  Copyright © 2016年 YUMIKO HARAGUCHI. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setupCell(cellitem: CellItem?) {
        if let item : CellItem = cellitem {
            self.addAttributedString(w: item.words)
            nameLabel.text = item.name
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addAttributedString(w : String) {
        let paragraph : NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraph.maximumLineHeight = 25
        paragraph.minimumLineHeight = 25
        paragraph.alignment = NSTextAlignment.left
        
        let attributed : NSAttributedString = NSAttributedString(string: w, attributes: [NSFontAttributeName: label.font, NSParagraphStyleAttributeName: paragraph, NSKernAttributeName: 1.2])
        label.attributedText = attributed
    }
    
}
