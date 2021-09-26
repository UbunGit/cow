//
//  InputModel.swift
//  Cow
//
//  Created by admin on 2021/9/26.
//

import Foundation
import UIKit

class InputModel<T>{
   
    var title:String = ""
    var key:String = ""
    var value:T? = nil
    
    var _valueView:UIView?
    var valueCell:UITableViewCell = UITableViewCell()

}

extension InputModel where T == Int{
    
    var valueCell: InputNumberTableCell{
        if _valueView == nil{
            _valueView = InputNumberTableCell.initWithNib()
        }
        return _valueView as! InputNumberTableCell
    }
    
    var identifier:String{
        "InputNumberView"
    }
}
