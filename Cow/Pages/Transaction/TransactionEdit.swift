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

    @IBOutlet weak var scrollerView: UIScrollView!
    @IBOutlet weak var typeBtn: UIButton!
    @IBOutlet weak var codeTF: UITextField!
    
    @IBOutlet weak var bdateDP: UIDatePicker!
    
    @IBOutlet weak var bpriceTF: UITextField!
    @IBOutlet weak var bcountTF: UITextField!
    
    @IBOutlet weak var bfreeTF: UITextField!
    
    @IBOutlet weak var sfreeTF: UITextField!
    
    @IBOutlet weak var spriceTF: UITextField!
    @IBOutlet weak var sdateDP: UIDatePicker!
    
    @IBOutlet weak var targetTF: AutoInputView!
    @IBOutlet weak var planTF: UITextField!
    @IBOutlet weak var remarkTF: UITextField!
    
    var editData = TransactionItem()
    override func viewDidLoad() {
        super.viewDidLoad()
     
        updateUI()
        targetTF.x5Btn.setBlockFor(.touchUpInside){ _ in
            self.targetTF.text = (self.bpriceTF.text.double()*1.05).price()
        }
        targetTF.x10Btn.setBlockFor(.touchUpInside) { _ in
            self.targetTF.text = (self.bpriceTF.text.double()*1.10).price()
        }
    }
    override func updateUI() {
        typeBtn.setTitle(editData.typeStr, for: .normal)
        codeTF.text = editData.code
        bdateDP.setDate(editData.bdate.string().date(), animated: true)
        bcountTF.text = editData.bcount.string()
        bpriceTF.text = editData.bprice.price()
        bfreeTF.text = editData.bfree.price()
        
        sdateDP.setDate(editData.sdate.string().date(), animated: true)
        spriceTF.text = editData.sprice.price()
        sfreeTF.text = editData.sfree.price()
        
        targetTF.text = editData.target.price()
        planTF.text = editData.plan
        remarkTF.text = editData.remarks
        
    }
    
    @IBAction func selectType(_ sender: Any) {
        selectsoockType { type in
            self.editData.type = type
            self.typeBtn.setTitle(self.editData.typeStr, for: .normal)
        }
    }
    @IBAction func selectCode(_ sender: Any) {
        if self.editData.type == 1 {
            let vc = StockBasicListVC()
            vc.selectClosure = ({ item in
                self.editData.code = item.code
                self.codeTF.text = self.editData.code
            })
            self.present(vc, animated: true, completion: nil)
        }
        if self.editData.type == 2 {
            let vc = ETFBaseListVC()
            vc.selectClosure = ({ item in
                self.editData.code = item["code"].string()
                self.codeTF.text = self.editData.code
            })
            self.present(vc, animated: true, completion: nil)
        }



    }
    @IBAction func closeBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func deleteClick(_ sender: UIButton) {
        let sql = "DELETE FROM rel_transaction WHERE id =  \(editData.id) "
        AF.af_update(sql) { result in
            self.view.loadingDismiss()
            switch result{
            case .success(_):
                self.view.success("删除成功")
                self.dismiss(animated: true, completion: nil)
                
            case .failure(let error):
            self.error(error)
            }
        }
    }
    @IBAction func commitClick(_ sender: Any) {
        guard let user = Global.share.user else {
            needLogin()
            return
        }
        
        editData.code = codeTF.text.string()
        editData.bdate = bdateDP.date.toString("yyyyMMdd")
        editData.bcount = bcountTF.text.int()
        editData.bprice = bpriceTF.text.double()
        editData.bfree = bfreeTF.text.double()
        
        editData.sprice = spriceTF.text.double()
        if editData.sprice>0 {
            editData.sdate = sdateDP.date.toString("yyyyMMdd")
            editData.sfree = sfreeTF.text.double()
        }

        editData.target = targetTF.text.double()
        editData.remarks = remarkTF.text.string()
        editData.plan = planTF.text.string()
        var sql = ""
        if editData.id > 0 {
            sql = """
                UPDATE  rel_transaction SET
                userid = \(user.userId),
                code = '\(editData.code)',
                bcount = \(editData.bcount),
                type =\(editData.type),
                bdate = '\(editData.bdate.string())',
                bprice = \(editData.bprice),
                bfree =  \(editData.bfree),
                sdate = '\(editData.sdate.string())',
                sprice = \(editData.sprice),
                sfree =\(editData.sfree),
                target = \(editData.target),
                plan='\(editData.plan)',
                remarks = '\(editData.remarks)'
                where id=\(editData.id)
                """
        }else{
            sql = ("""
                INSERT INTO rel_transaction
                (userid,code,bcount,type,bdate,bprice,bfree,sdate,sprice,sfree,target,plan,remarks)
                VALUES (
                \(user.userId),
                '\(editData.code)',
                \(editData.bcount),
                \(editData.type),
                '\(editData.bdate.string())',
                \(editData.bprice),
                \(editData.bfree),
                '\(editData.sdate.string())',
                \(editData.sprice),
                \(editData.sfree),
                \(editData.target),
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
                self.dismiss(animated: true, completion: nil)
                
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
    
    func commit(title:String = "你确定要这么做吗？" ,message:String?, typeAction:@escaping ((Int) -> Void)){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action1 =  UIAlertAction(title: "确 定", style: .default) { action in
            typeAction(1)
        }
        
        let action =  UIAlertAction(title: "取消", style: .cancel) { action in
            
        }
        alert.addAction(action1)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)

    }
}


class AutoInputView:UITextField{
    public lazy var x5Btn:UIButton = {
        let btn = UIButton.init(frame: .init(x: 0, y: 0, width: 44, height: 32))
        btn.setTitle("x5", for: .normal)
        btn.mb_radius = 4
        btn.mb_borderWidth = 0.5
        btn.mb_borderColor = .theme
        btn.setTitleColor(.theme, for: .normal)
        return btn
    }()
    public lazy var x10Btn:UIButton = {
        let btn = UIButton.init(frame: .init(x: 46, y: 0, width: 44, height: 32))
        btn.mb_borderWidth = 0.5
        btn.mb_radius = 4
        btn.mb_borderColor = .theme
        btn.setTitle("x10", for: .normal)
        btn.setTitleColor(.theme, for: .normal)
        return btn
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        let rvview = UIView.init(frame: .init(x: 0, y: 0, width: 90, height: 32))
        rightView = rvview
        rightViewMode = .always
        rightView?.addSubview(x5Btn)
        rightView?.addSubview(x10Btn)
    
     
    }
    
}

