//
//  TransactionListViewController.swift
//  Cow
//
//  Created by admin on 2021/9/2.
//

import UIKit
import Alamofire
import MJRefresh
import HandyJSON



class TransactionListViewController: BaseViewController {
    var state:TradeStatus = .didbuy // 0->持仓列表 1-> 已卖出
	var dataSouce:[[String:Any]] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        title = state == .didbuy ? "持仓列表" : "已卖列表"
        configTableview()
  
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        if Global.share.user == nil{
            needLogin()
            return
        }
        let datas = StockManage.share.datas
        if state == .didbuy{
            self.dataSouce = datas.filter{ $0["sprice"].double()<=0 }
        }else if state == .didsell{
            self.dataSouce = datas.filter{ $0["sprice"].double()>0 }
        }
        self.dataSouce = AF.api_reltransaction(state.rawValue)
		self.updateUI()
    }
    

}

extension TransactionListViewController:UITableViewDelegate,UITableViewDataSource{
    
    func configTableview()  {

        tableView.estimatedRowHeight = 120
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: "TransactionListCell", bundle: nil), forCellReuseIdentifier: "TransactionListCell")
        tableView.mj_header = MJRefreshGifHeader(refreshingBlock: {
            self.loadData()
        })
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSouce.count

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionListCell", for: indexPath) as! TransactionListCell
        let celldata = dataSouce[indexPath.row]
		cell.code = celldata["code"].string()
        cell.state = state
		cell.updateUI()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let celldata = dataSouce[indexPath.row]
        
		self.push_transaction(code: celldata["code"].string(),state: state)
      
    }
}

