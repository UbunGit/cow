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

class StockBasicListModel: HandyJSON {
    
    struct Stroe:HandyJSON{
        var name:String = ""
        var code:String = ""
        var area:String = ""
        var industry:String = ""
        var isfollow:Bool = false
        var market:String = ""
        var changeTime:String = "\(Date().toString("yyyy-MM-dd"))"

    }
    var stroes:[Stroe] = []


    required init() {
        
    }
    func updatestroes(finesh:(Error?)->()){
        do {
            let sql = """
                SELECT t1.*,  ifnull(t2.id>0,false) as isfollow FROM stockbasic t1
                LEFT JOIN follow t2 on t1.code=t2.pid
                """
            let smt = try sm.db?.prepare(sql)
            self.stroes = smt?.to_moden(Stroe.self) ?? []
        } catch let error {
            debugPrint(error.localizedDescription)
        }
        
    }
}

class StockBasicListVC: BaseViewController {

    var pageData = StockBasicListModel()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "股票列表"
        configNav()
        configTableview()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updatedata()
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

        tableView.estimatedRowHeight = 60
        tableView.register(UINib(nibName: "StockBasicListCell", bundle: nil), forCellReuseIdentifier: "StockBasicListCell")
        tableView.mj_header = MJRefreshGifHeader(refreshingBlock: {
            self.updateStockBasic()
        })
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageData.stroes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockBasicListCell", for: indexPath) as! StockBasicListCell
        cell.celldata = pageData.stroes[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
    }

    
    // 右侧按钮自定义
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let archiveAction = UIContextualAction(style: .normal, title: "关注") { [self] (action, view, finished) in
            do{
                try sm.inster_follow(type: 1, pid: pageData.stroes[indexPath.row].code)
                pageData.stroes[indexPath.row].isfollow = true
                tableView.reloadRow(at: indexPath, with: .automatic)
            }catch let error{
                self.view.error(error.localizedDescription)
            }
            
            finished(true)
        }
        
        
        return UISwipeActionsConfiguration(actions: [ archiveAction])
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
                self.updatedata()
                
            }
        }
    }
    func updatedata()  {
        self.pageData.updatestroes(finesh: { error in
            if error == nil{
                self.tableView.reloadData()
            }else{
                self.view.error(error!.localizedDescription)
            }
        })
    }

}
