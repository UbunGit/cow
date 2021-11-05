//
//  RecommendVC.swift
//  Cow
//
//  Created by admin on 2021/8/23.
//

import UIKit
import MJRefresh
class RecommendVC: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    var page = NSRange(location: 0, length: 1)
    var dataSouce:[Scheme] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loaddates()
        tableview.register(UINib(nibName: "RecommendCell", bundle: nil), forCellReuseIdentifier: "RecommendCell")
        tableview.rowHeight = 100
        
        tableview.separatorStyle = .none
        tableview.mj_footer = MJRefreshBackStateFooter(refreshingBlock: {
            self.dataSouce.removeAll()
            self.page.location=0
            self.loaddates()
            
        })
        tableview.mj_header = MJRefreshStateHeader(refreshingBlock: {
            self.page.location += 1
            self.loaddates()
            
        })
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    func loaddates() {
        view.loading()
        sm.af_kirogidates(limmit: page, type: "etf") { result in
            self.view.loadingDismiss()
            switch result{
            
            case .success(let value):
                if self.page.location==0 {
                    self.dataSouce = value.map{ item -> Kirogi in
                        let kir = Kirogi()
                        kir.date = item["date"].string()
                        return kir
                    }
                    self.tableview.scrollToBottom()
                }else{
                    let tem = value.map{ item -> Kirogi in
                        let kir = Kirogi()
                        kir.date = item["date"].string()
                        return kir
                    }
                    self.dataSouce += tem
                   
                }
                self.tableview.reloadData()
                
            case .failure(let err):
                self.view.error(err.localizedDescription)
            }
            self.tableview.mj_footer?.endRefreshing()
            self.tableview.mj_header?.endRefreshing()
        }
    }
    
    
    
}
extension RecommendVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSouce.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = dataSouce.count-indexPath.section-1
        return dataSouce[row].cellheight
    }
  
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "RecommendCell", for: indexPath) as! RecommendCell
        let row = dataSouce.count-indexPath.section-1
        cell.celldata = dataSouce[row]
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = dataSouce.count-indexPath.section-1
        let celldata = dataSouce[row]
        let vc = ETFRecommendDetaiVC()
        vc.pageData.scheme = celldata
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension RecommendVC:RecommendCellDelegate{
    func codeclick(code: String,name:String, celldata: Scheme) {
        let vc = ETFDetaiViewController()
        vc.scheme = celldata
        vc.code = code
        vc.name = name
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func reloadHeight() {
        tableview.reloadData()
    }
}
