//
//  SelectDateViewController.swift
//  Cow
//
//  Created by admin on 2021/11/16.
//

import UIKit

class SelectDateViewController: UIViewController {

    var commitBlock:((Date)->())? = nil
    @IBOutlet weak var dataPickView: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        dataPickView.backgroundColor = .white
        dataPickView.maximumDate = .init()

    }

    @IBAction func commitAction(_ sender: Any) {
        if let block = commitBlock{
            block(dataPickView.date)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancleAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension UIViewController{
    func selectDate(
        endBlock:@escaping (_ value:Date)->()
    ){
        
        let datavc = SelectDateViewController()
        
        datavc.commitBlock = { date in
            endBlock(date)
        }
        self.present(datavc, animated: true, completion: nil)
    }

}
