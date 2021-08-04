//
//  CameraAuthorZationVC.swift
//  CYYComponent
//
//  Created by admin on 2021/8/3.
//

import UIKit

class CameraAuthorZationVC: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: Bundle.init(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
      
    }
    @IBAction func openSysSetting(_ sender: Any) {
        self .mb_pushSysSetting()
    }

}
