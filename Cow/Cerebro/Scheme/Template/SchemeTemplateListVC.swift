//
//  KoinuListViewController.swift
//  Cow
//
//  Created by admin on 2021/9/20.
//

import UIKit
import MJRefresh
import Alamofire

class SchemeTemplateListVC: BaseViewController {
    /**
     入参
     **/
    var selectBlock:((_ id:[String:Any])->())? = nil
    
    var dataSouce:[[String:Any]] = []
    
    @IBOutlet weak var tableView: UITableView!
    lazy var refresh: UIButton = {
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        button.setImage(.init(systemName: "plus"), for: .normal)
        button.addBlock(for: .touchUpInside) { _ in
            let vc = SchemeTemplateEditVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return button
    }()
    
    // 添加
    lazy var mineItem: UIBarButtonItem = {
        let mineItem = UIBarButtonItem.init(customView: refresh)
        return mineItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "策略模版"
        configTableview()
        navigationItem.rightBarButtonItems = [mineItem]
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    override func updateUI() {
        tableView.mj_header?.endRefreshing()
        tableView.reloadData()
    }

}
extension SchemeTemplateListVC:UITableViewDelegate,UITableViewDataSource{
    
    func configTableview()  {

        tableView.estimatedRowHeight = 120
//        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: "KoinuListCell", bundle: nil), forCellReuseIdentifier: "KoinuListCell")
        tableView.mj_header = MJRefreshGifHeader(refreshingBlock: {
            self.loadData()
        })
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSouce.count

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KoinuListCell", for: indexPath) as! KoinuListCell
        cell.cellData = dataSouce[indexPath.row]
        cell.updateUI()
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let select = selectBlock{
            select(dataSouce[indexPath.row])
            self.dismiss(animated: true)
        }else{
            let vc = SchemeTemplateEditVC()
            vc.param  = dataSouce[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
 
    }

}

extension SchemeTemplateListVC{
    func loadData(){
        view.loading()
        AF.scheme_template_list()
            .responseModel([[String:Any]].self) { result in
                self.view.loadingDismiss()
                switch result{
                case.success(let value):
                    self.dataSouce = value
                case .failure(let err):
                    self.view.error(err)
                }
                self.updateUI()
            }
        
    }
}

