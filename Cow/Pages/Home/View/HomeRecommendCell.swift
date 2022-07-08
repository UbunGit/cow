//
//  HomeRecommendCell.swift
//  Cow
//
//  Created by admin on 2022/1/13.
//

import UIKit

class HomeRecommendCell: UICollectionViewCell {
	@IBOutlet weak var codeLab: UILabel! // 股票代码
	@IBOutlet weak var nameLab: UILabel! // 股票名称
	@IBOutlet weak var costLab: UILabel! // 成本价格
	@IBOutlet weak var priceLab: UILabel! // 当前价格
	@IBOutlet weak var orderLab: UILabel! // 买单
	
    @IBOutlet weak var sOrderLab: UILabel! // 卖单
    @IBOutlet weak var bgview: UIView!
	@IBOutlet weak var rateLab: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
