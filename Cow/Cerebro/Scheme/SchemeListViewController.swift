//
//  SchemeListViewController.swift
//  Cow
//
//  Created by admin on 2021/11/4.
//

import UIKit
import MJRefresh
import Alamofire

class SchemeListViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var dataSource:[[String:Any]] = []
    
    lazy var refresh: UIButton = {
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        button.setImage(.init(systemName: "plus"), for: .normal)
        button.setBlockFor(.touchUpInside) {[weak self] _ in
            let vc = SchemeEditViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
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
        makeUI()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    
    func makeUI(){
        navigationItem.rightBarButtonItems = [refreshItem]
        configTableview()
    }
    override func updateUI() {
        tableView.mj_header?.endRefreshing()
        tableView.reloadData()
    }
    
    func loadData(){
        view.loading()
        AF.scheme_list().responseModel([[String:Any]].self) { result in
            self.view.loadingDismiss()
            switch result{
            case .success(let value):
                self.dataSource = value
            case .failure(let err):
                self.view.error(err)
            }
            self.updateUI()
        }
    }


}
extension SchemeListViewController:UITableViewDelegate,UITableViewDataSource{
    func configTableview()  {

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: "SchemeListTableCell", bundle: nil), forCellReuseIdentifier: "SchemeListTableCell")
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
        return 120
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SchemeListTableCell", for: indexPath) as! SchemeListTableCell
        let data = dataSource[indexPath.row]
        cell.titleLab.text = data["name"].string()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = dataSource[indexPath.row]
        let vc = SchemeDesViewController()
        vc.schemeId = data["id"].int()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
