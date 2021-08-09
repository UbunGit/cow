//
//  UIView+xib.swift
//  CYYComponent
//
//  Created by admin on 2021/8/3.
//

import Foundation
@IBDesignable
public extension UIView {
    @IBInspectable
    var mb_radius: CGFloat {
        
        set {
            layer.cornerRadius = newValue
          
        }
        get {
            layer.cornerRadius
        }
    }
    
    var mb_borderWidth:CGFloat{
        set {
           
            layer.borderWidth = newValue
        }
        get {
            layer.borderWidth
        }
    }
    
    var mb_borderColor:UIColor?{
        set {
           
            layer.borderColor = newValue?.cgColor
        }
        get {
            UIColor.init(cgColor:layer.borderColor ?? UIColor.clear.cgColor)
        }
    }
    
    class func initWithNib() -> Self {

        let view = Bundle.main.loadNibNamed("\(Self.self)", owner: nil, options: nil)?.first as! Self
        return view
    }

    func initWithNib() -> Self {

        let view = Bundle.main.loadNibNamed("\(Self.self)", owner: nil, options: nil)?.first as! Self
        return view
    }
    
}





