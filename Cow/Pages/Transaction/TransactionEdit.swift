//
//  TransactionEdit.swift
//  Cow
//
//  Created by admin on 2021/9/3.
//

import UIKit
import Magicbox
import Alamofire



class TransactionEdit: BaseViewController {

    @IBOutlet weak var typeBtn: UIButton!
    @IBOutlet weak var codeTF: UITextField!
    
    @IBOutlet weak var bdateDP: UIDatePicker!
    
    @IBOutlet weak var bpriceTF: UITextField!
    @IBOutlet weak var bcountTF: UITextField!
    
    @IBOutlet weak var bfreeTF: UITextField!
    
    @IBOutlet weak var sfreeTF: UITextField!
    
    @IBOutlet weak var spriceTF: UITextField!
    @IBOutlet weak var scountTF: UITextField!
    @IBOutlet weak var sdateDP: UIDatePicker!
    
    @IBOutlet weak var targetTF: UITextField!
    
    @IBOutlet weak var planTF: UITextField!
    
    @IBOutlet weak var remarkTF: UITextField!
    
    var editData = TransactionEditModel()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func updateUI() {
        typeBtn.setTitle(editData.typeStr, for: .normal)
        codeTF.text = editData.code
        
        bdateDP.setDate(editData.bdate.toDate()!, animated: true)
        bcountTF.text = editData.bcount.string()
        bpriceTF.text = editData.bprice.price()
        bfreeTF.text = editData.bfree.price()
        
        sdateDP.setDate(editData.sdate.toDate()!, animated: true)
        scountTF.text = editData.scount.string()
        spriceTF.text = editData.sprice.price()
        sfreeTF.text = editData.sfree.price()
        
        targetTF.text = editData.target.price()
        planTF.text = editData.plan
        remarkTF.text = editData.remarks
    }
    
    @IBAction func selectType(_ sender: Any) {
        selectsoockType { type in
            self.editData.type = type
            
        }
    }
    @IBAction func commitClick(_ sender: Any) {
        guard let user = Global.share.user else {
            needLogin()
            return
        }
        editData.code = codeTF.text.string()
        editData.bcount = bcountTF.text.int()
        editData.bprice = bpriceTF.text.double()
        editData.bfree = bfreeTF.text.double()
        editData.bdate = bdateDP.date.toString("yyyyMMdd")
        var sql = ""
        if editData.id > 0 {
            sql = """
                UPDATE  rel_transaction SET
                userid = \(user.userId),
                code = '\(editData.code)',
                bcount = \(editData.bcount),
                type =\(editData.type),
                bdate = '\(editData.bdate)',
                bprice = \(editData.bprice),
                bfree =  \(editData.bfree),
                sdate = '\(editData.sdate)',
                sprice = \(editData.sprice),
                sfree =\(editData.sfree),
                plan='\(editData.plan)',
                remarks = '\(editData.remarks)')
                """
        }else{
            sql = ("""
                INSERT INTO rel_transaction
                (userid,code,bcount,type,bdate,bprice,bfree,sdate,sprice,sfree,plan,remarks)
                VALUES (
                \(user.userId),
                '\(editData.code)',
                \(editData.bcount),
                \(editData.type),
                '\(editData.bdate)',
                \(editData.bprice),
                \(editData.bfree),
                '\(editData.sdate)',
                \(editData.sprice),
                \(editData.sfree),
                '\(editData.plan)',
                '\(editData.remarks)')
                """)
        }
        view.loading()
        AF.af_update(sql) { result in
            self.view.loadingDismiss()
            switch result{
            case .success(_):
                self.view.success("成功")
            case .failure(let error):
            self.view.error(error.localizedDescription)
            }
        }
        
        
    }
    
}
extension UIViewController{
    
    func selectsoockType(_ typeAction:@escaping ((Int) -> Void)){
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


