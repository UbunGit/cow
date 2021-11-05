//
//  SchemeTemplateParamCell.swift
//  Cow
//
//  Created by admin on 2021/9/28.
//

import UIKit

class SchemeTemplateParamCell: UITableViewCell {

    @IBOutlet weak var typeLab: UILabel!
    @IBOutlet weak var defualLab: UILabel!
    @IBOutlet weak var desLab: UILabel!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var keyLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

  
    
}
