//
//  TableViewIntCell.swift
//  Cow
//
//  Created by admin on 2021/11/26.
//

import UIKit

class TableViewIntCell: UITableViewCell {

    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var valueTF: UITextField!
    @IBOutlet weak var arrowImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    
    
}
