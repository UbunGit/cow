//
//  Global.swift
//  Cow
//
//  Created by admin on 2021/8/28.
//

import Foundation
import Alamofire
import Magicbox



class Global {
    struct User {
        var userName:String = "未登录"
        var avatar: String = ""
        var userId:Int
    }
    private var _user:User? = nil
    
    var user:User?{
        get{
            if let tuser = _user  {
                return tuser
            }
            if let catchuser = UserDefaults.standard.object(forKey: "global.user") as? [String:Any] {
                if let uid = catchuser["id"] as? Int
                {
                    _user = User(userName: catchuser["name"].string(),
                                 avatar: catchuser["avatar"].string(),
                                 userId: uid)
                    return _user
                }
            }
            return nil
        }
        set{
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: "global.user")
            }
            _user = newValue
            
        }
    }
    
    static let `share` = Global()
    private init(){}
}

extension Global{
    
    func register(userName:String,passWord:String ,back:@escaping (Error?)->()) {
        let sql = sm.sql_register(userName: userName, passWord: passWord)
        AF.af_select(sql) { result in
            switch result{
            case .success(_):
                back(nil)
            case .failure(let error):
                back(error)
            }
        }
    }
    
    func login(userName:String,passWord:String,back:@escaping (Error?)->()) {
        let sql = sm.sql_login(userName: userName, passWord: passWord)
        AF.af_select(sql) { result in
            switch result{
            case .success(let value):
                guard let tuset = value.first else {
                    back(BaseError(code: -1, msg: "用户无注册或密码错误"))
                    return
                }
                guard (tuset["id"] as? Int) != nil else {
                    back(BaseError(code: -1, msg: "用户无注册或密码错误"))
                    return
                }
                Global.share.user = nil
                UserDefaults.standard.setValue(tuset, forKey: "global.user")
                UserDefaults.standard.synchronize()
                back(nil)
            case .failure(let error):
                back(error)
            }
        }
    }
}

extension UIViewController{
    func needLogin()  {
        let loginvc = loginViewController()
        loginvc.modalPresentationStyle = .fullScreen
        self.present(loginvc, animated: true, completion: nil)
    }
}



