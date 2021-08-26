//
//  RecommendCell.swift
//  Cow
//
//  Created by admin on 2021/8/23.
//

import UIKit

class RecommendCell: UITableViewCell {
    var celldata:Any?{
        didSet{
            updateUI()
        }
    }
    @IBOutlet weak var recommentCodeLab: UILabel!
    @IBOutlet weak var datelab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI() {
        
        guard let obj = celldata as? SchemeProtocol else {
            return
        }
        datelab.text = obj.date
        recommentCodeLab.text = try? obj.recommend()
            .map{
                return "\($0["code"].string())\($0["name"].string())\n"
                
        }.joined(separator: ",")
        
    }
    
}
