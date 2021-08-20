//
//  UIView+xib.swift
//  CYYComponent
//
//  Created by admin on 2021/8/3.
//

import Foundation
import UIKit
@IBDesignable

public extension UIView {
    @IBInspectable
    var mb_radius: CGFloat {
        
        set {
            layer.cornerRadius = newValue
            if newValue>0 {
                layer.masksToBounds = true
            }else{
                layer.masksToBounds = false
            }
        }
        get {
            layer.cornerRadius
        }
    }
    @IBInspectable
    var mb_borderWidth:CGFloat{
        set {
            
            layer.borderWidth = newValue
        }
        get {
            layer.borderWidth
        }
    }
    @IBInspectable
    var mb_borderColor:UIColor?{
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            UIColor.init(cgColor:layer.borderColor ?? UIColor.clear.cgColor)
        }
    }
    
    
    
}

var uiview_mb_lefttop_radius = 0
var uiview_mb_leftbottom_radius = 0
var uiview_mb_righttop_radius = 0
var uiview_mb_rightbottom_radius = 0

@IBDesignable
public extension UIView {
    
    
    @IBInspectable var mb_tlRadius:CGFloat{
        set {
            objc_setAssociatedObject(self, &uiview_mb_lefttop_radius, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
            addobjBounds()
            updatemask()
        }
        get {
            guard let rs = objc_getAssociatedObject(self, &uiview_mb_lefttop_radius) as? CGFloat else {
                return 0
            }
            return rs
        }
    }
    
    @IBInspectable var mb_blRadius:CGFloat{
        set {
            objc_setAssociatedObject(self, &uiview_mb_leftbottom_radius, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
            addobjBounds()
            updatemask()
        }
        get {
            guard let rs = objc_getAssociatedObject(self, &uiview_mb_leftbottom_radius) as? CGFloat else {
                return 0
            }
            return rs
        }
    }
    
    @IBInspectable var mb_trRadius:CGFloat{
        set {
            objc_setAssociatedObject(self, &uiview_mb_righttop_radius, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
            addobjBounds()
            updatemask()
        }
        get {
            guard let rs = objc_getAssociatedObject(self, &uiview_mb_righttop_radius) as? CGFloat else {
                return 0
            }
            return rs
        }
    }
    
    @IBInspectable var mb_brRadius:CGFloat{
        set {
            objc_setAssociatedObject(self, &uiview_mb_rightbottom_radius, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
            addobjBounds()
            updatemask()
        }
        get {
            guard let rs = objc_getAssociatedObject(self, &uiview_mb_rightbottom_radius) as? CGFloat else {
                
                return 0
                
            }
            return rs
        }
        
    }
    
    func addobjBounds()  {
        self.addObserverBlock(forKeyPath: "bounds") { _, _, _ in
            self.updatemask()
        }
    }
    func updatemask()  {
        layer.masksToBounds = true
        let path = UIBezierPath()
        
        let pathltl1 = UIBezierPath.init(roundedRect: CGRect(x: 0,
                                                             y: 0,
                                                             width: self.bounds.size.width/2,
                                                             height: self.bounds.size.height/2),
                                         byRoundingCorners: .topLeft,
                                         cornerRadii:CGSize(width: self.mb_tlRadius, height: self.mb_tlRadius))
        path.append(pathltl1)
        
        
        let pathllt2 = UIBezierPath.init(roundedRect: CGRect(x: self.bounds.size.width/2,
                                                             y: 0,
                                                             width: self.bounds.size.width/2,
                                                             height: self.bounds.size.height/2),
                                         byRoundingCorners: .topRight, cornerRadii:CGSize(width: self.mb_trRadius, height: self.mb_trRadius))
        path.append(pathllt2)
        
        
        let pathllt3 = UIBezierPath.init(roundedRect: CGRect(x: 0,
                                                             y: self.bounds.size.height/2,
                                                             width: self.bounds.size.width/2,
                                                             height: self.bounds.size.height/2),
                                         byRoundingCorners: .bottomLeft, cornerRadii:CGSize(width: self.mb_blRadius, height: self.mb_blRadius))
        path.append(pathllt3)
        
        
        
        let pathllt4 = UIBezierPath.init(roundedRect: CGRect(x: self.bounds.size.width/2,
                                                             y: self.bounds.size.height/2,
                                                             width: self.bounds.size.width/2,
                                                             height: self.bounds.size.height/2),
                                         byRoundingCorners: .bottomRight, cornerRadii:CGSize(width: self.mb_brRadius, height: self.mb_brRadius))
        path.append(pathllt4)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds;
        shapeLayer.path = path.cgPath;
        self.layer.mask = shapeLayer;
    }
    
}



public extension UIView {
    
    class func initWithNib() -> Self {
        
        let view = Bundle.main.loadNibNamed("\(Self.self)", owner: nil, options: nil)?.first as! Self
        return view
    }
    
    func initWithNib() -> Self {
        
        let view = Bundle.main.loadNibNamed("\(Self.self)", owner: nil, options: nil)?.first as! Self
        return view
    }
}





