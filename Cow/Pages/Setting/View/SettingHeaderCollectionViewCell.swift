//
//  SettingHeaderCollectionViewCell.swift
//  Cow
//
//  Created by admin on 2021/8/9.
//

import UIKit

class SettingHeaderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func updateUI() {
        nameLab.text = Global.share.user?.userName
    }

}
