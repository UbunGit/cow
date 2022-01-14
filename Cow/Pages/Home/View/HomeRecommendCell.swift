//
//  HomeRecommendCell.swift
//  Cow
//
//  Created by admin on 2022/1/13.
//

import UIKit

class HomeRecommendCell: UICollectionViewCell {
	@IBOutlet weak var codeLab: UILabel!
	@IBOutlet weak var nameLab: UILabel!
	@IBOutlet weak var costLab: UILabel!
	@IBOutlet weak var priceLab: UILabel!
	@IBOutlet weak var orderLab: UILabel!
	
	@IBOutlet weak var bgview: UIView!
	@IBOutlet weak var rateLab: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
