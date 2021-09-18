//
//  ETFBaseListVC.swift
//  Cow
//
//  Created by admin on 2021/8/29.
//

import UIKit
import MJRefresh
import Alamofire
class ETFBaseListModel {
    var delegate:BasetModelDelegate?
    var dataSouce:[[String:Any]] = []
    var range:NSRange = _NSRange(location: 0, length: 20)
    
    func updateDataSouce(){
        let sql = sm.select_etfbasic_follow(limmit:range)
        delegate?.view.loading()
        AF.af_select(sql) { result in
            self.delegate?.view.loadingDismiss()
            switch result{
            case .success(let value):
                if self.range.location==1 {
                    self.dataSouce = value
                }
                else{
                    self.dataSouce += value
                }
                self.delegate?.updateUI()
            case .failure(let err):
                self.delegate?.view.error(err.localizedDescription)
            }
        }
    }
    
    func follow(row:Int)  {
        let store = dataSouce[row]
        if let user = Global.share.user{
            let sql = sm.insteretffollow(code: store["code"].string(), userId: user.userId)
            AF.af_update(sql) { result in
                switch result{
                case .success(_):
                    self.delegate?.updateUI()
                case .failure(let err):
                    self.delegate?.view.error(err.localizedDescription)
                }
            }
        }
        else{
            delegate?.present(loginViewController(), animated: true, completion: nil)
            
        }
      
    }
}

class ETFBaseListVC: BaseViewController {
    var selectClosure:(([String:Any])->())?
    @IBOutlet weak var tableView: UITableView!
    
    lazy var tableHeadView:ETFBaseListSearchView = {
        let header = ETFBaseListSearchView()
        return header
    }()
   
    lazy var pageData: ETFBaseListModel = {
        let pageData = ETFBaseListModel()
        pageData.delegate = self
        return pageData
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTableview()
        pageData.updateDataSouce()

    }
    override func updateUI() {
        tableView.mj_footer?.endRefreshing()
        tableView.mj_header?.endRefreshing()
        tableView.reloadData()
    }

}

extension ETFBaseListVC:UITableViewDelegate,UITableViewDataSource{
    
    func configTableview()  {

        tableView.estimatedRowHeight = 60
        tableView.tableHeaderView = tableHeadView
        tableView.register(UINib(nibName: "ETFBaseListTableviewCell", bundle: nil), forCellReuseIdentifier: "ETFBaseListTableviewCell")
        tableView.mj_header = MJRefreshGifHeader(refreshingBlock: {
            self.pageData.range.location = 1
            self.pageData.updateDataSouce()
        })
        tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
       
            self.pageData.range.location += 1
            self.pageData.updateDataSouce()
        })
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageData.dataSouce.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ETFBaseListTableviewCell", for: indexPath) as! ETFBaseListTableviewCell
        cell.celldata = pageData.dataSouce[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let select = selectClosure {
            self.dismiss(animated: true) {
                select(self.pageData.dataSouce[indexPath.row])
            }
            return
        }
       let vc = ETFDetaiViewController()
        vc.code = pageData.dataSouce[indexPath.row]["code"].string()
        vc.name = pageData.dataSouce[indexPath.row]["name"].string()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    // 右侧按钮自定义
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let archiveAction = UIContextualAction(style: .normal, title: "关注") { [self] (action, view, finished) in
            pageData.follow(row: indexPath.row)
            pageData.dataSouce[indexPath.row]["follow"] = true
            tableView.reloadRow(at: indexPath, with: .automatic)
            
            finished(true)
        }
        
        
        return UISwipeActionsConfiguration(actions: [ archiveAction])
    }
    
    
}
