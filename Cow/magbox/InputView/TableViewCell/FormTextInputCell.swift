//
//  FormTextInputCell.swift
//  Cow
//
//  Created by admin on 2021/9/28.
//

import UIKit
import Magicbox

class FormTextInputCell: BaseInputCell {
   
    
    
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var textTF: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        selectionStyle = .none
    }
    override func setValue(_ value: Any?) {
        guard let data = value as? String else {
            return
        }
        textTF.text = data
    }
    override func value() -> Any?{
        return textTF.text
    }
    
}




