//
//  KoinuListViewController.swift
//  Cow
//
//  Created by admin on 2021/9/20.
//

import UIKit
import MJRefresh
import Alamofire

class KoinuListViewController: UIViewController {
    var dataSouce:[[String:Any]] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableview()
        loadData()
    }
    override func updateUI() {
        tableView.mj_header?.endRefreshing()
        tableView.reloadData()
    }

}
extension KoinuListViewController:UITableViewDelegate,UITableViewDataSource{
    
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
        let vc = KoinudefViewController()
        vc.schemeId  = dataSouce[indexPath.row]["id"].int()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    
}

extension KoinuListViewController{
   func loadData(){
    let sql = """
        select * from scheme
        """
    view.loading()
    AF.af_select(sql) { result in
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

