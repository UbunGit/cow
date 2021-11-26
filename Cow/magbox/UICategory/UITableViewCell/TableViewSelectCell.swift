//
//  TableViewSelectCell.swift
//  Cow
//
//  Created by admin on 2021/11/26.
//

import UIKit

class TableViewSelectCell: UITableViewCell {

    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var valueLab: UILabel!
    @IBOutlet weak var arrowImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }


    
}
