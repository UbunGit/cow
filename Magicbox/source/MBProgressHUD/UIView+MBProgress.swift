//
//  UIView+MBProgress.swift
//  CYYComponent
//
//  Created by admin on 2021/8/2.
//

import Foundation
import UIKit
import MBProgressHUD

/**
 提示框调用
 */
@objc public extension UIView {
    
    /**
     成功提示框,提示在window上
     e.g
     UIView.success()
     */
    static func success(_ msg:String = "成功", icon:String = "success.png"){
        KWindow??.success(msg)
    }
    
    /**
     成功提示框，提示在aview上
     e.g
     aview.success()
     */
    func success(_ msg:String = "成功", icon:String = "success.png"){
        DispatchQueue.main.async {
            let hud =  self.show(text: msg, icon:icon )
            hud.hide(animated: true, afterDelay: 1.5)
        }
    }
    
    /**
     错误提示框,提示在window上
     e.g
     UIView.error()
     */
    static func error(_ msg:String = "失败", icon:String = "error.png"){
        
        KWindow??.error(msg)
    }
    
    /**
     错误提示框,提示在aview上
     e.g
     aview.error()
     */
    func error(_ mag:String = "失败" , icon:String = "error.png"){
        DispatchQueue.main.async {
            let hud =  self.show(text: mag as String, icon: icon )
            hud.hide(animated: true, afterDelay: 1.5)
        }
    }
    
    /**
     错误提示框,提示在window上
     e.g
     UIView.error()
     */
    static func debug(_ msg:String = "失败", icon:String = "error.png"){
        
        KWindow??.debug(msg)
    }
    
    /**
     错误提示框,提示在aview上
     e.g
     aview.error()
     */
    func debug(_ mag:String = "失败" , icon:String = "error.png"){
        DispatchQueue.main.async {
            let hud =  self.show(text: mag as String, icon: icon )
            hud.bezelView.backgroundColor = .red
            hud.hide(animated: true, afterDelay: 2.5)
        }
    }
    
    /**
     加载框，提示在window上
     e.g
     UIView.lodding()
     */
    static func lodding(_ msg:String? = nil){
        KWindow??.lodding(msg)
    }
    
    /**
     加载框，提示在aview上
     e.g
     aview.lodding()
     */
    func lodding(_ msg:String? = nil){
        DispatchQueue.main.async {
            let hud = self.show(text: msg, icon: nil)
            hud.mode = .indeterminate
        }
    }
    
    /**
     清除加载框
     e.g
     UIView.loadingDismiss()
     */
    static func loadingDismiss(){
        KWindow??.loadingDismiss()
    }
    
    /**
     清除加载框
     e.g
     aview.loadingDismiss()
     */
    func loadingDismiss(){
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self, animated: false)
        }
        
    }
}

private extension UIView{
    func show(text:String?, icon:String?) -> MBProgressHUD {
        
        
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        if text != nil {
            
            hud.label.text = text;
            hud.label.textColor = .white
            hud.label.font = .systemFont(ofSize: 17)
        }
        if icon != nil {
            hud.customView = UIImageView.init(image: UIImage.init(named: icon ?? ""))
        }
        hud.bezelView.backgroundColor = .black    //背景颜色
        hud.mode = .customView;
        hud.isUserInteractionEnabled = false;
        hud.removeFromSuperViewOnHide = true;
        return hud
    }
}
