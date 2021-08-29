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
import Alamofire



class FollowListModel: HandyJSON {
    var type = 1{
        didSet{
            range = NSRange(location: 0, length: 10)
            updatedataSource()
        }
    }
    var delegate:BasetModelDelegate?
    var dataSource:[[String:Any]] = []
    var range = NSRange(location: 0, length: 10)
    required init() {
        
    }
    
    func updatedataSource() {
        delegate?.view.loading()
        let sql = type==1 ? sm.select_follow_stockbasic(limmit:range) : sm.select_follow_etfbasic(limmit:range)
        
        AF.af_select(sql) { result in
            self.delegate?.view.loadingDismiss()
            switch result{
            case .success(let value):
                self.dataSource = value
                self.delegate?.updateUI()
            case .failure(let err):
                self.delegate?.view.error(err.localizedDescription)
            }
        }
    }
    
    func unfollow(data:[String:Any]) {
        let table = type==1 ? "stockfollow" : "etffollow"
        let sql = "DELETE FROM \(table) where id= \(data["id"].int()) "
        delegate?.view.loading()
        AF.af_select(sql) { result in
            self.delegate?.view.loadingDismiss()
            switch result{
            case .success(_):
                
                self.delegate?.updateUI()
            case .failure(let err):
                self.delegate?.view.error(err.localizedDescription)
            }
        }
        
    }
}

class FollowListViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!

    lazy var pageData: FollowListModel = {
        let pdata = FollowListModel()
        pdata.delegate = self
        return pdata
    }()
    
    // 消息
    lazy var newbutton: UIButton = {
        let button = UIButton()
        button.mb_radius = 18
        button.setTitleColor(UIColor(named: "Background 5"), for: .normal)
        button.mb_borderColor = UIColor(named: "Background 3")
        button.mb_borderWidth = 1
        button.titleEdgeInsets = .init(top: 4, left: 8, bottom: 4, right: 8)
        button.setTitle("🔔", for: .normal)
        button.addTarget(self, action: #selector(settingDoit), for: .touchUpInside)
        return button
    }()
    
    // 消息
    lazy var newItem: UIBarButtonItem = {
      
        let newItem = UIBarButtonItem.init(customView: newbutton)
        
        return newItem
    }()
    @objc func settingDoit(){
        let setvc = FollowListSettingVC()
        setvc.pageData = self.pageData
        self.present(setvc, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItems = [newItem]
        configTableview()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pageData.updatedataSource()
    }
    override func updateUI() {
        newbutton.setTitle("\(pageData.type)", for: .normal)
        tableView.mj_header?.endRefreshing()
        tableView.reloadData()
    }
   
}

extension FollowListViewController:UITableViewDelegate,UITableViewDataSource{
    
    func configTableview()  {

        tableView.estimatedRowHeight = 60
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.mj_header = MJRefreshGifHeader(refreshingBlock: {
            self.pageData.updatedataSource()
        })
        tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.pageData.range.location += 1
            self.pageData.updatedataSource()
        })
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageData.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = pageData.dataSource[indexPath.row]["name"].string()
        return cell
    }
    // 左侧按钮自定义
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let leftAction = UIContextualAction(style: .normal, title: "取消关注") { (action, view, finished) in
       
            self.pageData.unfollow(data: self.pageData.dataSource[indexPath.row])
            self.pageData.dataSource.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRow(at: indexPath, with: .right)
            tableView.endUpdates()
            finished(true)
         
        }
        return UISwipeActionsConfiguration(actions: [leftAction])
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.mb_push("Cow.KLineViewController", params:
                        [
                            "code":pageData.dataSource[indexPath.row]["code"].string(),
                            "name":pageData.dataSource[indexPath.row]["name"].string()
                        ] )
        
    }
 
    
}
