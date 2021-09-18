//
//  KoinuSettingVC.swift
//  Cow
//
//  Created by admin on 2021/9/18.
//

import UIKit
import Alamofire
class KoinuSettingVC: UIViewController {

    var schemeId:Int? = nil
    @IBOutlet weak var nameT: UITextView!
    @IBOutlet weak var countT: UITextView!
    @IBOutlet weak var selectT: UITextView!
    @IBOutlet weak var whereT: UITextView!
    @IBOutlet weak var orderT: UITextView!
    @IBOutlet weak var limitT: UITextView!
    @IBOutlet weak var remarkT: UITextView!
  
    @IBOutlet weak var commitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

      
    }
    override func updateUI() {
        if schemeId != nil {
            commitBtn.setTitle("修改", for: .normal)
        }else{
            commitBtn.setTitle("新增", for: .normal)
        }
    }


    @IBAction func testClick(_ sender: Any) {
        do{
            var sql = ""
            if schemeId != nil {
                sql = """
                    UPDATE  scheme SET
                    'name' = '\(nameT.text.string())',
                    'count' = '\(countT.text.string())',
                    'select' = '\(selectT.text.string())',
                    'where' ='\(whereT.text.string())',
                    'order' = '\(orderT.text.string())',
                    'limit' = '\(limitT.text.string())',
                    'remarks' =  '\(remarkT.text.string())',
                    where id=\(schemeId.int())
                    """
            }else{
                sql = ("""
                    INSERT INTO scheme
                    ('name','count','select','where','order','limit','remarks')
                    VALUES (
                    '\(nameT.text.string())',
                    '\(countT.text.string())',
                    '\(selectT.text.string())',
                    '\(whereT.text.string())',
                    '\(orderT.text.string())',
                    '\(limitT.text.string())',
                    '\(remarkT.text.string())'
                    )
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
            
   
            
        }catch {
            print("Error when create regex!")
//            outTV.text = "\(error)"
        }
    }


}


