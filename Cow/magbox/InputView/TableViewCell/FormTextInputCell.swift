//
//  FormTextInputCell.swift
//  Cow
//
//  Created by admin on 2021/9/28.
//

import UIKit

class FormTextInputCell: BaseInputCell {
   
    
    
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var textTF: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textTF.lim
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

extension UITextField{
    private struct AssociatedKey {

        static var identifier: String = "maximumLimit"
        static var isAddNotif: String = "isAddNotif"

    }
    var maximumLimit:Int{
        set{
            objc_setAssociatedObject(self, &AssociatedKey.identifier, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get{
            guard let limit = objc_getAssociatedObject(self, &AssociatedKey.identifier) as? Int else{
                return 100
            }
            return limit
            
        }
    }
    
    var isAddNotif:Bool{
        set{
            objc_setAssociatedObject(self, &AssociatedKey.isAddNotif, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get{
            guard let isAddNotif = objc_getAssociatedObject(self, &AssociatedKey.isAddNotif) as? Int else{
                return false
            }
            return isAddNotif
            
        }
    }
    func addMotif(){
        if isAddNotif == false{
            
        }
    }
    
}
