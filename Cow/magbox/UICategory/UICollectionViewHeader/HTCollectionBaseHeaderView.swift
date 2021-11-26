//
//  HTCollectionBaseHeaderView.swift
//  HomeTown
//
//  Created by admin on 2021/10/13.
//

import UIKit

public class HTCollectionBaseHeaderView: UICollectionReusableView {

    @IBOutlet public weak var roundView: UIView!
    @IBOutlet public weak var moreLab: UILabel!
    @IBOutlet public weak var arrowImageView: UIImageView!
    @IBOutlet public weak var moreBtn: UIButton!
    @IBOutlet public weak var titleLab: UILabel!
    public  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
