//
//  KoinuListCell.swift
//  Cow
//
//  Created by admin on 2021/9/20.
//

import UIKit

class KoinuListCell:UITableViewCell {
   

    var cellData:Any? = nil
    @IBOutlet weak var desLab: UILabel!
    @IBOutlet weak var nameLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func updateUI() {
        guard let data = cellData as? [String:Any] else {
           return
        }
        nameLab.text = data["name"].string()
        desLab.text = data["remarks"].string()
    }

}
