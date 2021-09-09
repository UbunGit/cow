//
//  TransactionListViewController.swift
//  Cow
//
//  Created by admin on 2021/9/2.
//

import UIKit
import Alamofire
import MJRefresh

struct TransactionEditModel {
    var id = 0
    var userId = 0
    var code = ""
    var type = 1 // 股票类型 1->股票 2->ETF
    var bdate = "" // 买入时间
    var bprice = 0.0 // 买入价格
    var bcount = 0 //买入数量
    var bfree = 0.0 // 买入手续费
    var sdate = "" // 卖出时间
    var sprice = 0.0 // 卖出价格
    var scount = 0 //卖出数量
    var sfree = 0.0 // 卖出手续费
    var target = 0.0 // 目标价格
    var plan = "" // 策略
    var remarks = "" // 备注
    
    // get
    var typeStr:String{
        switch type {
        case 1:
            return "股票"
        case 2:
            return "ETF"
        default:
            return "选择股票类型"
        }
    }
}

class Transaction {
    var delegate:TransactionListCell? = nil
    var code:String=""
    var name:String=""
    var datas:[[String:Any]] = []
    
    var storeCount:Int = 0
    
    func loadeDef()  {
        
        
        let sql = """
            SELECT  id,bdate,bprice,bfree,bcount,sdate,sprice,sfree,target,plan,remarks from rel_transaction
            WHERE code = "\(code)"
            ORDER BY bdate
            """
        
        AF.af_select(sql) { [self] result in
            switch result{
            case .success(let value):
                self.datas = value
            case .failure(let err):
                self.delegate?.error(err.localizedDescription)
            }
            
            
            
            self.storeCount = datas.filter { $0["sdate"].string().count<=0 }.reduce(0){
                print("reduce\($0)")
                print("bcount\($1["bcount"].int())")
                return $0 + $1["bcount"].int()
            }
            
            self.delegate?.updateUI()
        }
    }
}



class TransactionListViewController: BaseViewController {
    
    var dataSouce:[Transaction] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableview()
        loadData()
    }

    @IBAction func addTransaction(_ sender: Any) {
        self.present(TransactionEdit(), animated: true, completion: nil)
    }
    override func updateUI() {
        tableView.mj_header?.endRefreshing()
        self.tableView.reloadData()
    }
    
    func loadData()  {
        
        let sql = """
            SELECT t1.code,t2.name FROM (SELECT code from rel_transaction  GROUP BY code) t1
            LEFT JOIN etfbasic t2 ON t1.code=t2.code
            """
        view.loading()
        AF.af_select(sql) { result in
            self.view.loadingDismiss()
            switch result{
            case .success(let value):
                self.dataSouce = value.map({ item in
                    let data = Transaction()
                    data.code = item["code"].string()
                    data.name = item["name"].string()
                    return data
                })
            case .failure(let err):
                self.view.error(err.localizedDescription)
            }
            self.updateUI()
          
        }
    }
    

}

extension TransactionListViewController:UITableViewDelegate,UITableViewDataSource{
    
    func configTableview()  {

        tableView.estimatedRowHeight = 120
        tableView.register(UINib(nibName: "TransactionListCell", bundle: nil), forCellReuseIdentifier: "TransactionListCell")
        tableView.mj_header = MJRefreshGifHeader(refreshingBlock: {
            self.loadData()
        })
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSouce.count

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        180
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionListCell", for: indexPath) as! TransactionListCell
        cell.celldata = dataSouce[indexPath.row]
        cell.celldata?.delegate = cell
        cell.celldata?.loadeDef()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//       let vc = ETFDetaiViewController()
//        vc.code = pageData.dataSouce[indexPath.row]["code"].string()
//        vc.name = pageData.dataSouce[indexPath.row]["name"].string()
//        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    
}

