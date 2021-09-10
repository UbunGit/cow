//
//  ETFBaseListTableviewCell.swift
//  Cow
//
//  Created by admin on 2021/8/29.
//

import UIKit

class ETFBaseListTableviewCell: UITableViewCell {

    @IBOutlet weak var flowImageView: UIImageView!
    @IBOutlet weak var codeLab: UILabel!
    @IBOutlet weak var nameLab: UILabel!
    var celldata:[String:Any]?{
        didSet{
            updateUI()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   override func updateUI()  {
        guard let tdata = celldata else {
            return
        }
        nameLab.text = tdata["name"].string()
        codeLab.text = tdata["code"].string()
        flowImageView.isHidden = !(tdata["code"].int()==1)
        
        
    }
}
