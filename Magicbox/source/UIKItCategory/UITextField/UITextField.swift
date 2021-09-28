//
//  UItext.swift
//  Alamofire
//
//  Created by admin on 2021/9/28.
//

import Foundation

public extension UITextField{
    private struct AssociatedKey {

        static var identifier: String = "maximumLimit"
        static var isAddNotif: String = "isAddNotif"

    }
    var maximumLimit:Int{
        set{
            objc_setAssociatedObject(self, &AssociatedKey.identifier, newValue, .OBJC_ASSOCIATION_ASSIGN)
            addMotif()
        }
        get{
            guard let limit = objc_getAssociatedObject(self, &AssociatedKey.identifier) as? Int else{
                return 0
            }
            return limit
            
        }
    }
    
    var isAddNotif:Bool{
        set{
            objc_setAssociatedObject(self, &AssociatedKey.isAddNotif, newValue, .OBJC_ASSOCIATION_ASSIGN)
            
        }
        get{
            guard let isAddNotif = objc_getAssociatedObject(self, &AssociatedKey.isAddNotif) as? Bool else{
                return false
            }
            return isAddNotif
            
        }
    }
    func addMotif(){
        if isAddNotif == false{
            NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextField.textDidChangeNotification, object: nil)
            isAddNotif = true
        }
    }
    
    
    @objc func textDidChange()  {
        characterTruncation()
    }
    func characterTruncation()  {
        
        guard let _:UITextRange = self.markedTextRange
            
        else {
            //记录当前光标的位置，后面需要进行修改
            let cursorPostion = self.offset(from: self.endOfDocument, to: self.selectedTextRange!.end)
            if let cstr = text {
                var str:String = cstr
                //限制最大输入长度
                if str.count > maximumLimit && maximumLimit>0 {
                    str = String(str.prefix(maximumLimit))
                }
                self.text = str
            }

            //让光标停留在正确的位置
            let targetPosion = self.position(from: self.endOfDocument, offset: cursorPostion)!
            self.selectedTextRange = self.textRange(from: targetPosion, to: targetPosion)
            
            return
        }
    }
    
}
