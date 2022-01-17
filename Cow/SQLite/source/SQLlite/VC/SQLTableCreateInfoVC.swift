//
//  SQLTableCreateInfoVCViewController.swift
//  Cow
//
//  Created by admin on 2022/1/17.
//

import UIKit
import Alamofire

class SQLTableCreateInfoVC: UIViewController {
    var tableName:String = ""
    var rootIN = 0 //表来源 0->服务器 1->本地
    
    @IBOutlet weak var infoLab: UILabel!
    override func viewDidLoad() {
        title = "创建信息"
        super.viewDidLoad()
        loadData()
   
    }
    
    func loadData(){
        let sql = """
SELECT * FROM sqlite_master
        WHERE name="\(tableName)"
"""
        if rootIN == 0{
            AF.select(sql).responseModel([[String:Any]].self) {[weak self] result in
                switch result{
                case .success(let vlaue):
                    self?.infoLab.text = "\(vlaue)"
                case .failure(let err):
                    self?.infoLab.text = "\(err)"
                }
            }
        }else if rootIN == 1{
            let info =  sm.select(sql)
            infoLab.text = "\(info)"
        }
  
    }



}
