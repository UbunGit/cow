//
//  FormRoundHeader.swift
//  Cow
//
//  Created by admin on 2021/9/28.
//

import UIKit

class FormRoundHeader: UITableViewHeaderFooterView {

    override func awakeFromNib() {
      
        contentView.backgroundColor = .clear
        tintColor = .clear
    }
    @IBOutlet weak var titleLab: UILabel!
    
}
