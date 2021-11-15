//
//  SchemeSettingPoolVC.swift
//  Cow
//
//  Created by admin on 2021/11/12.
//

import UIKit
import MJRefresh
import Alamofire

class SchemeSettingPoolVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var schemeId:Int = 0
    var dataSource:[[String:Any]] = []
    lazy var refresh: UIButton = {
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        button.setImage(.init(systemName: "plus"), for: .normal)
        button.addBlock(for: .touchUpInside) {[weak self] _ in
            self?.selectsoockType({ type in
                if type == 1 {
                    let vc = StockBasicListVC()
                    vc.selectClosure = ({ item in
                        var data:[String:Any] = [:]
                        data["code"] = item.code
                        data["type"] = 0
                        data["name"] = item.name
                        self?.dataSource.append(data)
                        self?.addCodetoScheme(item: data)

                    })
                    self?.present(vc, animated: true, completion: nil)
                }
                if type == 2 {
                    let vc = ETFBaseListVC()
                    vc.selectClosure = ({ item in
                        var data:[String:Any] = [:]
                        data["code"] = item["code"]
                        data["type"] = 1
                        data["name"] = item["name"]
                        self?.dataSource.append(data)
                        self?.addCodetoScheme(item: data)
                    })
                    self?.present(vc, animated: true, completion: nil)
                }
            })
        }
        return button
    }()
    
    // 添加
    lazy var refreshItem: UIBarButtonItem = {
        let mineItem = UIBarButtonItem.init(customView: refresh)
        return mineItem
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItems = [refreshItem]
        configTableview()
        self.title = "股票池"
        loadData()

    }
    override func updateUI() {
        tableView.mj_footer?.endRefreshing()
        tableView.mj_header?.endRefreshing()
        tableView.reloadData()
    }
    // 加载股票池
    func loadData(){
        self.view.loading()
        AF.scheme_pool(schemeId).responseModel([[String:Any]].self) {[weak self] result in
            self?.view.loadingDismiss()
            switch result{
            case .success(let value):
                self?.dataSource = value
            
            case .failure(let err):
                self?.view.error(err)
            }
            self?.updateUI()
        }
      
    }
    // 给策略股票池添加数据
    func addCodetoScheme(item:[String:Any]){
        self.view.loading()
        AF.scheme_addCode(self.schemeId, item: item)
        
            .responseModel([String:Any].self) {[weak self] result in
                self?.view.loadingDismiss()
                switch result{
                case .success(_):
                    self?.view.success("添加成功")
                    
                case .failure(let err):
                    self?.view.error(err)
                }
                self?.updateUI()
            }
    }
    
    func deleteCode(id:Int){
        self.view.loading()
        AF.scheme_deleteCode(self.schemeId,codeId: id)
            .responseModel([String:Any].self) {[weak self] result in
                self?.view.loadingDismiss()
                switch result{
                case .success(_):
                    self?.view.success("删除成功")
                    
                case .failure(let err):
                    self?.view.error(err)
                }
                self?.updateUI()
            }
    }
    
 

}
extension SchemeSettingPoolVC:UITableViewDelegate,UITableViewDataSource{
    func configTableview()  {

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: "StockBasicListCell", bundle: nil), forCellReuseIdentifier: "StockBasicListCell")
        tableView.mj_header = MJRefreshGifHeader(refreshingBlock: {
            self.loadData()
        })
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockBasicListCell", for: indexPath) as! StockBasicListCell
        let data = dataSource[indexPath.row]
        cell.nameLab.text = data["name"].string()
        cell.codeLab.text = data["code"].string()
        cell.flowImageView.isHidden = true
        return cell
    }
    // 右侧按钮自定义
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let archiveAction = UIContextualAction(style: .destructive, title: "删除") { [weak self] (action, view, finished) in
            
            self?.commit(message: "是否确认删除", typeAction: { _ in
                
                if let data = self?.dataSource[indexPath.row]{
                    self?.deleteCode(id: data["id"].int())
                    self?.dataSource.remove(at: indexPath.row)
                    finished(true)
                }
                
            })
            
            
        }
        
        
        return UISwipeActionsConfiguration(actions: [ archiveAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
