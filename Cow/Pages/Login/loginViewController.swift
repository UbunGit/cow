//
//  loginViewController.swift
//  Cow
//
//  Created by admin on 2021/8/28.
//

import UIKit

class loginViewController: BaseViewController {
    
    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var commitBtn: UIButton!
    @IBOutlet weak var userTF: UITextField!
    @IBOutlet weak var passwdTF: UITextField!
    var islogin = true // 0->登陆 1 注册
    {
        didSet{
            if islogin {
                changeBtn.setTitle("免费注册", for: .normal)
                commitBtn.setTitle("登  录", for: .normal)
            }else{
                changeBtn.setTitle("已有账号", for: .normal)
                commitBtn.setTitle("注  册", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userTF.text = "test"
        passwdTF.text = "test"
    }
    
    @IBAction func changType(_ sender: Any) {
        islogin.toggle()
    }
    
    @IBAction func dismisclick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func commitDoit(_ sender: Any) {
        guard
            let user = userTF.text,
            let paswd = passwdTF.text else {
            view.error("请输入用户名")
            return
        }
        if user.count<3{
            view.error("用户名不能少于6个字符")
            return
        }
        if paswd.count<3{
            view.error("密码不能少于6个字符")
            return
        }
        if islogin {
            view.loading()
            Global.share.login(userName: user, passWord: paswd) { error in
                self.view.loadingDismiss()
                if error == nil{
                    self.view.success("登录成功")
                    self.dismiss(animated: true, completion: nil)
                }else{
                    self.view.error(error!.localizedDescription)
                }
            }
        }else{
            view.loading()
            Global.share.register(userName: user, passWord: paswd) { error in
                self.view.loadingDismiss()
                if error == nil{
                    self.view.success("注册成功")
                    self.islogin = true
                }else{
                    self.view.error(error!.localizedDescription)
                }
            }
        }
    }
    
}
