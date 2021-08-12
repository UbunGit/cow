//
//  StockBasicListVC.swift
//  Cow
//
//  Created by admin on 2021/8/9.
//

import UIKit
import Magicbox
import HandyJSON
import MJRefresh

class StockBasicListVC: BaseViewController {

    var datasource:[StockBasic] = []{
        didSet{
            tableView.reloadData()
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "股票列表"
        configNav()
        configTableview()
        updateDataSource()
    }
    
    // 刷新
    lazy var refreshItem: UIBarButtonItem = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        let searchItem = UIBarButtonItem.init(customView: button)
        button.addTarget(self, action: #selector(updateStockBasic), for: .touchUpInside)
        return searchItem
    }()
    
   

    func configNav()  {
//        navigationItem.rightBarButtonItems = [refreshItem]
    }

}
extension StockBasicListVC:UITableViewDelegate,UITableViewDataSource{
    
    func configTableview()  {
//        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 60
        tableView.register(UINib(nibName: "StockBasicListCell", bundle: nil), forCellReuseIdentifier: "StockBasicListCell")
        tableView.mj_header = MJRefreshGifHeader(refreshingBlock: {
            self.updateStockBasic()
        })
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockBasicListCell", for: indexPath) as! StockBasicListCell
        cell.celldata = datasource[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let web = WebViewController()
        self.navigationController?.pushViewController(web, animated: true)
        let codes = datasource[indexPath.row].code.components(separatedBy: ".")
        if codes.count == 2 {
            web.url = "https://quotes.sina.cn/hs/company/quotes/view/\(codes[1])\(codes[0])"
        }
        
    }
    // 左侧按钮自定义
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let leftAction = UIContextualAction(style: .normal, title: "左侧") { (action, view, finished) in
            
            finished(true)
        }
        
        
        return UISwipeActionsConfiguration(actions: [leftAction])
    }
    
    // 右侧按钮自定义
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "删除") { (action, view, finished) in
            
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//
//            // 回调告知执行成功，否则不会删除此行！！！
//            finished(true)
        }
        
        
        
        let archiveAction = UIContextualAction(style: .normal, title: "关注") { [self] (action, view, finished) in
            do{
               try sm.inster_follow(type: 1, pid: datasource[indexPath.row].code)
            }catch let error{
                self.view.error(error.localizedDescription)
            }
            
            finished(true)
        }
        
        
        return UISwipeActionsConfiguration(actions: [deleteAction, archiveAction])
    }
    
    
}
extension StockBasicListVC{
    @objc func updateStockBasic(){
        view.loading()
        StockBasic.api_update { error in
            self.view.loadingDismiss()
           
            self.tableView.mj_header?.endRefreshing()
            if error != nil{
                self.view.error(error!.msg)
            }else{
                self.updateDataSource()
          
            }
        }
    }
    
    func updateDataSource()  {
        guard let result = StockBasic().select()  else {
            return
        }
        datasource = result
        
    }
}
