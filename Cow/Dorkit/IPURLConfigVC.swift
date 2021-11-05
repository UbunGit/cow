//
//  IPURLConfigVC.swift
//  Cow
//
//  Created by admin on 2021/9/29.
//

import UIKit
import Magicbox
import IQKeyboardManager
class IPURLConfigVC: UIViewController {
    var dataSouce:[String] =  []
    @IBOutlet weak var tableView: UITableView!
    
    lazy var inputTF:UGTextField = {
        let tf = UGTextField.init(frame: CGRect(x: 0, y: KHeight-44-KSafeBottom, width: KWidth, height: 44))
        let commitBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 44, height: 32))
        commitBtn.setTitle("添加", for: .normal)
        commitBtn.setTitleColor(.theme, for: .normal)
        commitBtn.setBlockFor(.touchUpInside) { _ in
            if let value = tf.text{
                self.addipdata(value)
            }
            tf.resignFirstResponder()
            
        }
        tf.rightView = commitBtn
        tf.rightViewMode = .always
        tf.text = "http://"
        tf.offset = 8
        tf.backgroundColor = .cw_bg5.alpha(0.5)
        return tf
    }()

    func addipdata(_ url:String){
        if url.count<=0{
            UIView.error("不能为空")
            return
        }
        if dataSouce.contains(url){
            UIView.error("已存在")
           return
        }else{
            dataSouce.append(url)
            UserDefaults.standard.set(dataSouce, forKey: "IPURLConfigVC.urls")
        }
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // 监听键盘的显示和隐藏
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        view.addSubview(inputTF)
        title = "ip设置"
        configTableview()
        if let urls:[String] = UserDefaults.standard.object(forKey: "IPURLConfigVC.urls") as?
            [String]{
            dataSouce = urls
        }
        addipdata(baseurl)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared().isEnabled = true
    }
    
    @objc func keyboardWillShow(_ aNotification: Notification?) {
        // 获取键盘的高度
        let userInfo = aNotification?.userInfo
        let aValue = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        let keyboardRect = aValue?.cgRectValue
        let height = keyboardRect?.size.height ?? 0.0

        var frame = inputTF.frame

        let offset = height - (CGFloat(KHeight) - frame.maxY)

        let duration = CGFloat((userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.0)
        frame.origin.y -= offset
        UIView.animate(withDuration: TimeInterval(duration), animations: { [self] in
            if offset > 0 {
                inputTF.frame = frame
                view.layoutIfNeeded()
            }
        })
    }

    // 当键退出时调用
    @objc func keyboardWillHide(_ aNotification: Notification?) {
        let userInfo = aNotification?.userInfo
        let duration = CGFloat((userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.0)
        var frame = inputTF.frame
        frame.origin.y = KHeight - 44 - KSafeBottom
        UIView.animate(withDuration: TimeInterval(duration), animations: { [self] in
            inputTF.frame = frame
            view.layoutIfNeeded()
        })
    }
}

extension IPURLConfigVC:UITableViewDelegate,UITableViewDataSource{
    
    func configTableview()  {

        tableView.estimatedRowHeight = 120
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: "IPURLConfigCell", bundle: nil), forCellReuseIdentifier: "IPURLConfigCell")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSouce.count

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IPURLConfigCell", for: indexPath) as! IPURLConfigCell
        let title = dataSouce[indexPath.row]
        cell.selectRemark.isHidden = (title != baseurl)
        cell.titleLab.text = title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = dataSouce[indexPath.row]
        self.selectHandle(title)
        
    }
    func selectHandle(_ url:String){
        let alert = UIAlertController(title: "选择你的操作", message: nil, preferredStyle: .actionSheet)
        let action1 =  UIAlertAction(title: "编辑", style: .default) { action in
            self.dataSouce.removeAll { $0 == url }
            
            self.inputTF.text = url
            self.inputTF.becomeFirstResponder()
            self.tableView.reloadData()
        }
        let action2 =  UIAlertAction(title: "选中", style: .default) { action in
            baseurl = url
            self.tableView.reloadData()
        }
        let action3 =  UIAlertAction(title: "删除", style: .default) { action in
            self.dataSouce.removeAll { $0 == url }
            UserDefaults.standard.set(self.dataSouce, forKey: "IPURLConfigVC.urls")
            self.tableView.reloadData()
        }
        let action =  UIAlertAction(title: "取消", style: .cancel) { action in
            
        }
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}
