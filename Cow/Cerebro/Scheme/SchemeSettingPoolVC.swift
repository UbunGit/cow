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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableview()
        self.title = "股票池"
        loadData()

    }
    override func updateUI() {
        tableView.mj_footer?.endRefreshing()
        tableView.mj_header?.endRefreshing()
        tableView.reloadData()
    }
    func loadData(){
        AF.scheme_pool(schemeId).responseModel([[String:Any]].self) { result in
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
extension SchemeSettingPoolVC:UITableViewDelegate,UITableViewDataSource{
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
