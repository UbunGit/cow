//
//  ETFDetaiSettingVC.swift
//  Cow
//
//  Created by admin on 2021/8/28.
//

import UIKit

class ETFDetaiSettingVC: BaseViewController {
    
    var setdata:ETFDetaiModen?{
        didSet{
            reloadUI()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func reloadUI() {
        guard let sdata = setdata else {
            return
        }
        for aview in view.subviews {
            if let btn = aview as? UIButton{
                btn.isSelected = (sdata.speed == btn.tag)
            }
        }
    }
    

    @IBAction func speedClick(_ sender: UIButton) {
        guard let sdata = setdata else {
            return
        }
        sdata.speed = sender.tag
        reloadUI()
        self.dismiss(animated: true, completion: nil)
    }
    

}
