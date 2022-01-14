//
//  loginViewController.swift
//  Cow
//
//  Created by admin on 2021/8/28.
//

import UIKit

class loginViewController: UIViewController {
    
    @IBOutlet weak var titleLab: UILabel!
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
                titleLab.text = "密码登陆"
            }else{
                changeBtn.setTitle("已有账号", for: .normal)
                commitBtn.setTitle("注  册", for: .normal)
                titleLab.text = "免费注册"
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
            let user = userTF.text else {
            view.error("请输入用户名")
            return
        }
        guard let paswd = passwdTF.text else{
            view.error("请输入密码")
            return
        }
        login(userName: user, passWord: paswd)
        
        
    }
    
}
extension loginViewController{
    func login(userName:String,passWord:String){
        if userName.count<3{
            view.error("用户名不能少于6个字符")
            return
        }
        if passWord.count<3{
            view.error("密码不能少于6个字符")
            return
        }
        if islogin {
            view.loading()
            Global.share.login(userName: userName, passWord: passWord) { error in
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
            Global.share.register(userName: userName, passWord: passWord) { error in
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
