//
//  TransactionListTableHeader.swift
//  Cow
//
//  Created by admin on 2021/9/2.
//

import UIKit

class TransactionListTableHeader: UIControl {
    var value:Int = 1{
        didSet{
            self.sendActions(for: .valueChanged)
        }
    }
    
    @IBAction func valueChange(_ sender: Any) {
       
        guard let btn = sender as? UIButton else{
            return
        }
        if btn.tag == value{
            return
        }
        if let obtn = viewWithTag(value) as? UIButton{
            obtn.isSelected = false
            obtn.mb_borderColor = .clear
        
        }
        value = btn.tag
        btn.isSelected = true
        btn.mb_borderColor = .theme
  
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        if let obtn = viewWithTag(value) as? UIButton{
            obtn.isSelected = true
            obtn.mb_borderColor = .theme
       
        }
      
    }
}

