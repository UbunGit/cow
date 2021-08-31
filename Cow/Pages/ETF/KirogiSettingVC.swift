//
//  ETFDetaiSettingVC.swift
//  Cow
//
//  Created by admin on 2021/8/28.
//

import UIKit

class KirogiSettingVC: BaseViewController {
    
    var setdata:ETFDetaiModen?
    @IBOutlet weak var speedStackView: UIStackView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var signalTitleLab: UILabel!
    var speed:Int = 0
    var signal:Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadUI()
    }
    func reloadUI() {
        guard let sdata = setdata else {
            return
        }
        for aview in speedStackView.subviews {
            if let btn = aview as? UIButton{
                btn.isSelected = (sdata.speed == btn.tag)
            }
        }
    }
    

    @IBAction func speedClick(_ sender: UIButton) {
        speed = sender.tag
    }
    @IBAction func signalValueChange(_ sender: UISlider) {
        signal = sender.value
        signalTitleLab.text = .init(format: "信号量：%0.2f", signal)
    }
    
    @IBAction func commitClick(_ sender: Any) {
     
      
        UserDefaults.standard.setValue(speed, forKey: "kirogi.speed")
        UserDefaults.standard.setValue(signal, forKey: "kirogi.signal")
        UserDefaults.standard.synchronize()
        guard let sdata = setdata else {
            return
        }
        sdata.speed = speed
        self.dismiss(animated: true, completion: nil)
        reloadUI()
    }
    
}
