//
//  StockBasicListCell.swift
//  Cow
//
//  Created by admin on 2021/8/10.
//

import UIKit

class StockBasicListCell: UITableViewCell {
    
    var celldata:StockBasicListModel.Stroe?=nil{
        didSet{
            updateUI()
        }
    }
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var codeLab: UILabel!
    @IBOutlet weak var flowImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func updateUI()  {
        guard let tdata = celldata else {
            return
        }
        nameLab.text = tdata.name
        codeLab.text = tdata.code
        flowImageView.isHidden = !tdata.follow
        
        
    }
    
}
