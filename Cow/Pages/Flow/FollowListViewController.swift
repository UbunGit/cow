//
//  FlooowListViewController.swift
//  Cow
//
//  Created by admin on 2021/8/12.
//

import UIKit
import MJRefresh
import HandyJSON
import Magicbox

class FollowListModel: HandyJSON {
    var dataSource:[FollowModel] = []
    required init() {
        
    }
   
    
    func updatedataSource(type:Int,finesh:(Error?)->()) {
        do {
            dataSource = try sm.select_stockbasic_follow(fitter: "t1.type=1").to_model()
         
            finesh(nil)
        } catch let error {
            debugPrint(error.localizedDescription)
            finesh(error)
        }
        
    }
    
    func unfollow(data:FollowModel, finesh:(Error?)->()) {
        do {
            try sm.delete_follow(id: data.id)
            try sm.delete_stockdaily(code: data.code)
            finesh(nil)
        } catch let error {
            debugPrint(error.localizedDescription)
            finesh(error)
        }
        
    }
}

class FollowListViewController: CViewController {

    @IBOutlet weak var tableView: UITableView!
    var pageData:FollowListModel = FollowListModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableview()
        
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    func updateData(){
        pageData.updatedataSource(type: 1) { error in
            if error == nil{
                tableView.mj_header?.endRefreshing()
                tableView.reloadData()
            }else{
                self.view.error(error!.localizedDescription)
            }
        }
    }
}

extension FollowListViewController:UITableViewDelegate,UITableViewDataSource{
    
    func configTableview()  {

        tableView.estimatedRowHeight = 60
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.mj_header = MJRefreshGifHeader(refreshingBlock: {
            self.updateData()
        })
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageData.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = pageData.dataSource[indexPath.row].name
        return cell
    }
    // 左侧按钮自定义
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let leftAction = UIContextualAction(style: .normal, title: "取消关注") { (action, view, finished) in
            do{
                self.pageData.unfollow(data: self.pageData.dataSource[indexPath.row]){ error in
                    if error == nil{
                        self.pageData.dataSource.remove(at: indexPath.row)
                        tableView.beginUpdates()
                        tableView.deleteRow(at: indexPath, with: .right)
                        tableView.endUpdates()
                        finished(true)
                    }else{
                        self.view.error(error!.localizedDescription)
                        finished(true)
                        return
                    }
                }
            }
        }
        return UISwipeActionsConfiguration(actions: [leftAction])
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.mb_push("Cow.KLineViewController", params:
                        [
                            "code":pageData.dataSource[indexPath.row].code,
                            "name":pageData.dataSource[indexPath.row].name
                        ] )
        
    }
 
    
}
