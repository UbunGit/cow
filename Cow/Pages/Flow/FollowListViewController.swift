//
//  FlooowListViewController.swift
//  Cow
//
//  Created by admin on 2021/8/12.
//

import UIKit
import MJRefresh

class FollowListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var dataSource:[FollowModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableview()
        updateData()
    }
    
    func updateData()  {
        do {
            try dataSource = FollowModel().fitter(type: 1)
            self.tableView.mj_header?.endRefreshing()
            tableView.reloadData()
        } catch let error {
            view.error(error.localizedDescription)
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
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row].name
        return cell
    }
    // 左侧按钮自定义
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let leftAction = UIContextualAction(style: .normal, title: "取消关注") { (action, view, finished) in
            do{
                try self.dataSource[indexPath.row].unfollow()
            }catch let error{
                self.view.error(error.localizedDescription)
                return
            }
            self.dataSource.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRow(at: indexPath, with: .right)
            
            tableView.endUpdates()
            finished(true)
        }
        
        
        return UISwipeActionsConfiguration(actions: [leftAction])
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
    }
 
    
}
