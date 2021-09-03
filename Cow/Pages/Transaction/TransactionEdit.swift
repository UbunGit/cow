//
//  TransactionEdit.swift
//  Cow
//
//  Created by admin on 2021/9/3.
//

import UIKit

class TransactionEdit: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func selectType(_ sender: Any) {
        selectsoockType { type in
            
        }
    }
    
}
extension UIViewController{
    func selectsoockType(_ typeAction:@escaping ((Int?) -> Void)){
        let alert = UIAlertController(title: "选择股票类型", message: nil, preferredStyle: .actionSheet)
        let action1 =  UIAlertAction(title: "股票", style: .default) { action in
            typeAction(1)
        }
        let action2 =  UIAlertAction(title: "ETF", style: .default) { action in
            typeAction(2)
        }
        let action =  UIAlertAction(title: "取消", style: .cancel) { action in
            
        }
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)

    }
}


