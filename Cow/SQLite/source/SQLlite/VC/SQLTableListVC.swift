//
//  SQLTableListVC.swift
//  Cow
//
//  Created by admin on 2021/8/17.
//

import UIKit
import MJRefresh
import Alamofire

class SQLTableListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var tables:[[String:Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableview()
        updatetables()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func updatetables()  {
        let url = "\(baseurl)/select"
        let param = ["sql":"""
                        SELECT * FROM sqlite_master
                        WHERE type="table"
                        """
        ]
        view.loading()
        
        AF.request(url, method: .post, parameters: param, encoder: JSONParameterEncoder.default)
            .responseModel([[String:Any]].self) { result in
                self.view.loadingDismiss()
                switch result{
                case .success(let value):
                    self.tables = value
                    self.tableView.mj_header?.endRefreshing()
                    self.tableView.reloadData()
                case .failure(let error):
                    self.view.error(error.localizedDescription)
                }
            }
    }

}

extension SQLTableListVC:UITableViewDelegate,UITableViewDataSource{
    
    func configTableview()  {
        
        tableView.estimatedRowHeight = 60
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.mj_header = MJRefreshGifHeader(refreshingBlock: {
            self.updatetables()
        })
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return tables.count
        }else{
            return creatdTabledic.count
        }
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "服务器"
        }else{
            return "本地"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            if let name = tables[indexPath.row]["name"] as? String {
                cell.textLabel?.text = name
            }else{
                cell.textLabel?.text = "--"
            }
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
            let table = creatdTabledic[indexPath.row]
           
            if let name = table["name"] {
                cell.textLabel?.text = name
            }else{
                cell.textLabel?.text = "--"
            }
            
            return cell
        }
      
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.mb_push("Cow.SQLTableInfoVC", params:["tableInfo":tables[indexPath.row]])
    }
    
    // 右侧按钮自定义
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 0 {
            let archiveAction = UIContextualAction(style: .normal, title: "删除表") { [self] (action, view, finished) in
                do{
                    if let name = tables[indexPath.row]["name"] as? String {
                        try sm.dropaftercreatetable(tablename: name)
                        self.updatetables()
                    }else{
                        view.error("表名为空")
                    }
                    
                }catch {
                    self.view.error(error.localizedDescription)
                }
                
                finished(true)
            }
            
            
            return UISwipeActionsConfiguration(actions: [ archiveAction])
        }else{
            let archiveAction = UIContextualAction(style: .normal, title: "删除表") { [self] (action, view, finished) in
                do{
                    let table = creatdTabledic[indexPath.row]
                   
                    if let name = table["name"] {
                        try sm.dropaftercreatetable(tablename: name)
                        self.updatetables()
                    }else{
                        view.error("表名为空")
                    }

                }catch {
                    self.view.error(error.localizedDescription)
                }
                
                finished(true)
            }
            
            
            return UISwipeActionsConfiguration(actions: [ archiveAction])
        }
      
    }
    
    
    
    
}

