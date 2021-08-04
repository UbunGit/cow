//
//  UIViewController+Route.swift
//  CYYComponent
//
//  Created by admin on 2021/7/29.
//
import UIKit
import Foundation
import YYKit

@objc public extension UIViewController{
    
    /**:
     页面跳转
     注意：对应类接受参数的属性必须用 @Objc 修饰，否则赋值不成功
     e.g:
     包名:CYYCommonAPP 类名:XIBSFViewController
     Swift： [self mb_pushNotRepeat:@"CYYCommonAPP.XIBSFViewController" params:@{@"name":@"test"}];
     OC：    [self mb_push:@"XIBOCViewController" params:@{@"name":@"test"}];
     */
    func mb_push(_ clsStr:String, params:NSDictionary)  {
        
        guard let nav = self.nav else {
            return
        }
        
        
        guard let cls = NSClassFromString(clsStr) as? UIViewController.Type  else {
            self.mb_push("CYYComponent.ExViewController", params: ["params":params,"pushname":clsStr])
            return
        }
        
        if (cls.isSubclass(of: UIViewController.self) == true) {
            let vc = cls.init()
            vc.modelSet(with: params as! [AnyHashable : Any])
            nav.pushViewController(vc, animated: true)
        }else{
            return
        }
        
    }
    
    /**:
     页面跳转，如果nav中已经存在相同类型，就返回到已存在的那个类
     注意:对应类接受参数的属性必须用 @Objc 修饰，否则赋值不成功
     e.g:
     包名:CYYCommonAPP 类名:XIBSFViewController
     Swift： [self mb_pushNotRepeat:@"CYYCommonAPP.XIBSFViewController" params:@{@"name":@"test"}];
     OC：    [self mb_push:@"XIBOCViewController" params:@{@"name":@"test"}];
     */
    func mb_pushNotRepeat(_ clsStr:String, params:NSDictionary)  {
        
        guard let nav = self.navigationController else {
            return
        }
        
        guard let cls = NSClassFromString(clsStr) as? UIViewController.Type  else {
            self.mb_push("CYYComponent.ExViewController", params: ["params":params,"pushname":clsStr])
            return
        }
        for tvc in nav.viewControllers {
            if ( NSStringFromClass(type(of: tvc)) == NSStringFromClass(cls))  {
                tvc.modelSet(with: params as! [AnyHashable : Any])
                nav.popToViewController(tvc, animated: true)
                return
            }
        }
        self.mb_push(clsStr, params: params)
        
    }
    
    func mb_pushSysSetting() {
        
        guard let seturl = URL.init(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(seturl) {
            UIApplication.shared.open(seturl, options: [:]) { status in
                return
            }
        }
        
    }
    
    private var nav:UINavigationController?{
        
        var nav:UINavigationController
        if self.isKind(of: UINavigationController.self) {
            nav = self as! UINavigationController
        }else{
            guard let tnav = self.navigationController else {
                return nil
            }
            nav = tnav
        }
        return nav
    }
    
}



/**
 push不成功跳转的类
 */
class ExViewController: UIViewController {
    
    lazy var paramlab: UILabel = {
        var paramlab = UILabel.init()
        paramlab.textColor = UIColor.black
        paramlab.numberOfLines = 0
        paramlab.text = "参数"
        return paramlab
    }()
    
    lazy var namelab: UILabel = {
        var namelab = UILabel.init()
        namelab.textColor = UIColor.black
        namelab.numberOfLines = 0
        
        return namelab
    }()
    
    @objc var pushname:String?
    @objc var params:NSDictionary?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(paramlab)
        view.addSubview(namelab)
        
        if params != nil {
            paramlab.text = "\(params ?? [:])"
        }
        if pushname != nil {
            namelab.text = "\(pushname ?? "")"
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        namelab.frame = CGRect(x: 0, y: 84, width: view.bounds.size.width, height: 50)
        paramlab.frame = CGRect(x: 0, y: namelab.frame.origin.y+namelab.frame.size.height, width: view.bounds.size.width, height: 300)
    }
    
    
    
}


