//
//  SQLTableInfoVC.swift
//  Cow
//
//  Created by admin on 2021/8/17.
//

import UIKit
import Alamofire
class SQLTableInfoVC: UIViewController {
 
    @objc var tableInfo:[String:Any] = [:]
   
    var tableName:String!
    var rootIN = 0 //表来源 0->服务器 1->本地
    
    @IBOutlet weak var createSql: UILabel!
    @IBOutlet weak var countLab: UILabel!
    @IBOutlet weak var lastDataLab: UILabel!
    @IBOutlet weak var infoLab: UILabel!
    
    lazy var dataView:SqlTableView = {
        
        let table = SqlTableView()
        table.rootIn = rootIN
        table.tableName = tableName
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "简介"
        view.addSubview(dataView)
        updateUI()

    }
    override func updateUI()  {
        dataView.loadData()
        guard let tablename = tableInfo["name"] as? String else {
            return
        }

        view.loading()
        var lastdata:[[String:Any]] = []
        let group =  DispatchGroup.init()
        group.enter()
        if let sql = tableInfo["sql"] as? String {
                    createSql.text = sql
                }
        let url = "\(baseurl)/select"
        let param = ["sql":sm.lastsql(table: tablename,isasc:true)]
        AF.request(url, method: .post, parameters: param, encoder: JSONParameterEncoder.default)
            .responseModel([[String:Any]].self) { result in
                
                switch result{
                case .success(let value):
                    lastdata = value
                    
                case .failure(let error):
                    self.view.error(error.localizedDescription)
                }
                group.leave()
            }
        
        group.enter()
        var countdata:[[String:Any]] = []
        let counturl = "\(baseurl)/select"
        let countparam = ["sql":sm.countsql(table: tablename)]
        AF.request(counturl, method: .post, parameters: countparam, encoder: JSONParameterEncoder.default)
            .responseModel([[String:Any]].self) { result in
                
                switch result{
                case .success(let value):
                    countdata = value
                    
                case .failure(let error):
                    self.view.error(error.localizedDescription)
                }
                group.leave()
            }
        
        group.notify(queue: .main) {
            self.view.loadingDismiss()
            self.lastDataLab.text = lastdata.description
            self.countLab.text = "数据量：\(countdata.description)"
        }
        
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dataView.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(450)
        }
    }

}

class SQLLocalTableInfoVC:SQLTableInfoVC{
    
    override func updateUI()  {
        dataView.loadData()
        guard let tablename = tableInfo["name"] as? String else {
            return
        }

    
 
        if let sql = tableInfo["sql"] as? String {
                    createSql.text = sql
                }
        
        let lastqsl = sm.lastsql(table: tablename,isasc:true)
        let lastdata = sm.select(lastqsl)
        let countsql = sm.countsql(table: tablename)
        let countdata = sm.select(countsql)
        self.lastDataLab.text = lastdata.description
        self.countLab.text = "数据量：\(countdata.description)"
       
        
    }
    
}
