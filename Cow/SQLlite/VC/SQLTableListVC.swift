//
//  SQLTableListVC.swift
//  Cow
//
//  Created by admin on 2021/8/17.
//

import UIKit
import MJRefresh

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
        do {
            self.tables = try sm.tables()
            tableView.mj_header?.endRefreshing()
            tableView.reloadData()
        } catch  {
            view.error(error.localizedDescription)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tables.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let name = tables[indexPath.row]["name"] as? String {
            cell.textLabel?.text = name
        }else{
            cell.textLabel?.text = "--"
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.mb_push("Cow.SQLTableInfoVC", params:["tableInfo":tables[indexPath.row]])
    }
    
    // 右侧按钮自定义
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let archiveAction = UIContextualAction(style: .normal, title: "删除表") { [self] (action, view, finished) in
            do{
                if let name = tables[indexPath.row]["name"] as? String {
                    try sm.droptable(tablename: name)
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

