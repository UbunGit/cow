//
//  FollowListSettingVC.swift
//  Cow
//
//  Created by admin on 2021/8/29.
//

import UIKit

class FollowListSettingVC: BaseViewController {
    var pageData:FollowListModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    override func updateUI() {
        guard let data = pageData else {
            return
        }
        let btn1 = view.viewWithTag(1)
        let btn2 = view.viewWithTag(2)
        if data.type == btn1?.tag{
            btn1?.backgroundColor = .red
            btn2?.backgroundColor = .white
        }else{
            btn2?.backgroundColor = .red
            btn1?.backgroundColor = .white
        }
        
    }
    @IBAction func typeBtnClick(_ sender: UIButton) {
        guard let data = pageData else {
            return
        }
        data.type = sender.tag
        self.dismiss(animated: true, completion: nil)
        
    }
}
