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
    
    lazy var headrtView:CollectionHeaderView = {
        let view = CollectionHeaderView()
        view.backgroundColor = .red
        view.dataSource = ["服务器","本地","创建表"]
        view.setBlockFor(.valueChanged) { _ in
            let value = view.value
            self.tableView.scrollToRow(at: .init(row: 0, section: value), at: .top, animated: true)
        }
        return view
    }()
    
    var tables:[[String:Any]] = []
    var localTables:[[String:Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(headrtView)
        configTableview()
        updatetables()
        updatelocalTables()
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
    
    func updatelocalTables(){
        let sql = """
                        SELECT * FROM sqlite_master
                        WHERE type="table"
                        """
        localTables =  sm.select(sql)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headrtView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(44)
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
        3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        switch section{
        case 0:
            return  tables.count
        case 1:
            return  localTables.count
        case 2:
            return  creatdTabledic.count
        default:
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return  "服务器"
        case 1:
            return  "本地"
        case 2:
            return  "创建表"
        default:
            return nil
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
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
            let table = localTables[indexPath.row]
           
            if let name = table["name"]  as? String {
                cell.textLabel?.text = name
            }else{
                cell.textLabel?.text = "--"
            }
            
            return cell
        }
        else{
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
        switch indexPath.section{
        case 0:
            let vc = TableInfoPageViewController()
            vc.tableName = tables[indexPath.row]["name"].string()
            vc.rootIN = indexPath.section
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = TableInfoPageViewController()
            vc.tableName = localTables[indexPath.row]["name"].string()
            vc.rootIN = indexPath.section
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
      
//        self.mb_push("Cow.SQLTableInfoVC", params:["tableInfo":tables[indexPath.row]])
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

