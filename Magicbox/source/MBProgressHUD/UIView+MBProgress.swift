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
            hud.tag = 6000
            hud.customView?.backgroundColor = .systemGreen
            DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
                self .hubhidden(6000)
            }
            
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
            hud.tag = 6001
            hud.label.textColor = .white
            hud.customView?.backgroundColor = .red
            DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
                self .hubhidden(6001)
            }
        }
    }
    
    /**
     错误提示框,提示在window上
     e.g
     UIView.error()
     */
    static func debug(_ msg:NSString = "失败", icon:String = "error.png"){
        
        KWindow??.debug(msg)
    }
    
    /**
     错误提示框,提示在aview上
     e.g
     aview.error()
     */
    func debug(_ mag:NSString = "失败" , icon:String = "error.png"){
        DispatchQueue.main.async {
            let hud =  self.show(text: mag as String, icon: icon )
            hud.customView?.backgroundColor = .red
            hud.tag = 6002
            DispatchQueue.main.asyncAfter(deadline: .now()+3.5) {
                self .hubhidden(6002)
            }
        }
        
    }
    
    
    /**
     加载框，提示在window上
     e.g
     UIView.lodding()
     */
    static func loading(_ msg:String? = nil){
        DispatchQueue.main.async {
        KWindow??.loading(msg)
        }
    }
    
    /**
     加载框，提示在aview上
     e.g
     aview.lodding()
     */
    func loading(_ msg:String? = nil){

        DispatchQueue.main.async {
            let hud = self.show(text: msg, icon: nil)
            hud.mode = .indeterminate
            hud.tag = 6003
            
        }
    }
    @objc func loadingProgress(progress:Float){
        
        DispatchQueue.main.async {
            guard let hub = self.viewWithTag(6003) as? MBProgressHUD else{
                return
            }
            
            hub.progress = Float(progress)
        }

    }
    
    /**
     清除加载框
     e.g
     UIView.loadingDismiss()
     */
    static func loadingDismiss(){
        DispatchQueue.main.async {
            KWindow??.loadingDismiss()
        }
    }
    
    /**
     清除加载框
     e.g
     aview.loadingDismiss()
     */
    func loadingDismiss(){
        DispatchQueue.main.async {
            self.hubhidden(6003)
        }
        
    }
    
    func alertView(aview:UIView) {
        let bgview = UIView(frame: self.bounds)
        bgview.tag = 6004
        DispatchQueue.main.async {
            
            bgview.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
            bgview.alpha = 0
            self.addSubview(bgview)
            bgview.addSubview(aview)
            aview.center = self.center
            UIView.animate(withDuration: 0.35) {
                bgview.alpha = 1
            }
            self.isUserInteractionEnabled = false;
        }
       
        
    }
    
    func hiddenAlertView(aview:UIView) {
        
        guard let bgview = self.viewWithTag(6004)  else {
            return
        }
        DispatchQueue.main.async{
            bgview.removeFromSuperview()
            self.isUserInteractionEnabled = true;
        }
    }
}

private extension UIView{
    
    func show(text:String?, icon:String?) -> MBProgressHUD {
        
        self.isUserInteractionEnabled = false;
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
        hud.removeFromSuperViewOnHide = true;
        return hud
    }
    
    func hubhidden(_ viewTag:Int)  {
        DispatchQueue.main.async{
            self.isUserInteractionEnabled = true;
            for aview in self.subviews{
                if aview.tag == viewTag {
                    guard let hub = aview as? MBProgressHUD  else {
                        return
                    }
                    hub.hide(animated: false)
                }
            }
         
         
        }
    }
}
