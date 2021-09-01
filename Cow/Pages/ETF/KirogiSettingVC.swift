//
//  ETFDetaiSettingVC.swift
//  Cow
//
//  Created by admin on 2021/8/28.
//

import UIKit

class KirogiSettingVC: BaseViewController {
    
    var kirogi:Kirogi = Kirogi()
    @IBOutlet weak var speedStackView: UIStackView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var signalView: UISlider!
    @IBOutlet weak var isDefualBtn: UIButton!
    @IBOutlet weak var signalTitleLab: UILabel!
    var speed:Int = 0
    var signal:Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speed = kirogi.speed
        signal = kirogi.signal
        updateUI()
    }
    override func updateUI() {
        signalTitleLab.text = .init(format: "信号量：%0.2f", signal)
        for aview in speedStackView.subviews {
            if let btn = aview as? UIButton{
                btn.isSelected = (speed == btn.tag)
            }
        }
    }
    

    @IBAction func speedClick(_ sender: UIButton) {
        speed = sender.tag
        updateUI()
    }
    @IBAction func signalValueChange(_ sender: UISlider) {
        signal = sender.value
        updateUI()
    
    }
    
    @IBAction func isDefualClick(_ sender: Any) {
        isDefualBtn.isSelected.toggle()
    }
    @IBAction func commitClick(_ sender: Any) {
        if isDefualBtn.isSelected {
            UserDefaults.standard.setValue(speed, forKey: "kirogi.speed")
            UserDefaults.standard.setValue(String(format: "%0.2f", signal), forKey: "kirogi.signal")
            UserDefaults.standard.synchronize()
        }
        self.dismiss(animated: true, completion: nil)
        updateUI()
    }
    
}
