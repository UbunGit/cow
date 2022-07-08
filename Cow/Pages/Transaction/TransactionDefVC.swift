//
//  TransactionDefVC.swift
//  Cow
//
//  Created by admin on 2021/9/10.
//

import UIKit
import MJRefresh
import Alamofire
import YYKit
import UniformTypeIdentifiers
class TransactionDefVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
	var code:String = "" // 代码
    var type:Int = 1 // 类型
    var state:TradeStatus = .didbuy // 状态 0 未卖出 1 卖出
    
    var datas:[TransactionItem] = []
    
    
    lazy var addbtn: UIButton = {
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        button.setImage(.init(systemName: "plus.circle"), for: .normal)
        button.addBlock(for: .touchUpInside) { _ in
            let vc = TransactionEdit()
            let editdata = TransactionItem()
            editdata.userid = Global.share.user!.userId
            editdata.code = self.code
            editdata.type = self.type
            vc.editData = editdata
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
        return button
    }()
    
    lazy var refresh: UIButton = {
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        button.setImage(.init(systemName: "arrow.clockwise"), for: .normal)
        button.addBlock(for: .touchUpInside) { _ in
            self.loadData()
        }
        
        return button
    }()
    
    // 我
    lazy var mineItem: UIBarButtonItem = {
        
        let mineItem = UIBarButtonItem.init(customView: refresh)
        
        return mineItem
    }()
    lazy var addItem: UIBarButtonItem = {
        
        let mineItem = UIBarButtonItem.init(customView: addbtn)
        
        return mineItem
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
		let titleLab = UILabel()
		titleLab.numberOfLines = 2
		titleLab.font = .systemFont(ofSize: 14)
		self.navigationItem.titleView = titleLab
        titleLab.text = StockManage.share.storeName(code)
		
        loadData()
        navigationItem.rightBarButtonItems = [mineItem,addItem]
        configTableview()
     
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    override func updateUI() {
        tableView.mj_header?.endRefreshing()
        refresh.layer.removeAllAnimations()
        tableView.reloadData()
    }
    
    
    lazy var tableCategoryHeader:TransactionListTableHeader = {
        let header = TransactionListTableHeader.initWithNib()
        header.setvalue(state.rawValue+1)
        header.addBlock(for: .valueChanged) {[weak self] _ in
			
            self?.state = .init(rawValue: header.value-1) ?? .didbuy
            self?.loadData()
        }
        return header
    }()
    
    
    
}

extension TransactionDefVC:UITableViewDelegate,UITableViewDataSource{
    func configTableview()  {
        
        tableView.estimatedRowHeight = 120
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: "TransactionListCell", bundle: nil), forCellReuseIdentifier: "TransactionListCell")
        tableView.register(UINib(nibName: "TransactionDefCell", bundle: nil), forCellReuseIdentifier: "TransactionDefCell")

        
        tableView.mj_header = MJRefreshGifHeader(refreshingBlock: {
            self.loadData()
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
		return datas.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 180
        }else{
            return 120
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionListCell", for: indexPath) as! TransactionListCell
            cell.code = code
            cell.state = state
            cell.updateUI()
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionDefCell", for: indexPath) as! TransactionDefCell
			cell.cellData = datas[indexPath.row]
            cell.updateUI()
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section==0 {
            return
        }
        
        
        let vc = TransactionEdit()
        vc.editData = datas[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section{
        case 1:
            return 44
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableCategoryHeader
    }
}

extension TransactionDefVC{


	func loadData(){
        if state == .didbuy {
            datas = Transaction.soreDatas(code)
        }else if state == .didsell{
            datas = Transaction.finishDatas(code)
        }
		self.updateUI()
	}
}

enum TradeStatus:Int{
    case didbuy = 0
    case didsell = 1
}
