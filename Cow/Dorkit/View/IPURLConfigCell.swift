//
//  IPURLConfigCell.swift
//  Cow
//
//  Created by admin on 2021/11/2.
//

import UIKit

class IPURLConfigCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    @IBOutlet weak var selectRemark: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
 
    
}
