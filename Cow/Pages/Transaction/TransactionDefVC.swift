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
class TransactionDefVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data:Transaction = Transaction()
    
    
    lazy var addbtn: UIButton = {
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        button.setImage(.init(systemName: "plus.circle"), for: .normal)
        button.addBlock(for: .touchUpInside) { _ in
            let vc = TransactionEdit()
            vc.editData = TransactionEditModel( userId: Global.share.user!.userId, code: self.data.code, type: 1)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
        return button
    }()
    
    lazy var refresh: UIButton = {
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        button.setImage(.init(systemName: "arrow.clockwise"), for: .normal)
        button.addBlock(for: .touchUpInside) { _ in
            self.reloadData()
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
        self.title = "持仓详细"
        data.delegate = self
        navigationItem.rightBarButtonItems = [mineItem,addItem]
        configTableview()
     
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    override func updateUI() {
        tableView.mj_header?.endRefreshing()
        refresh.layer.removeAllAnimations()
        tableView.reloadData()
    }
    func reloadData()  {
        refresh.beginrefresh()
        data.loadeDef(type: tableCategoryHeader.value)
        data.updatePrice()
    }
    
    lazy var tableCategoryHeader:TransactionListTableHeader = {
        let header = TransactionListTableHeader.initWithNib()
        header.addBlock(for: .valueChanged) { _ in
            self.reloadData()
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
            self.reloadData()
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return data.datas.count
        
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
            cell.celldata = data
            cell.refreshBtn.isHidden = true
            cell.updateUI()
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionDefCell", for: indexPath) as! TransactionDefCell
            cell.cellData = data.datas[indexPath.row]
            cell.price = data.price
            cell.updateUI()
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section==0 {
            return
        }
        guard  let moden = TransactionEditModel.deserialize(from: data.datas[indexPath.row] as [String:Any]) else {
            view.error("数据转换失败")
            return
        }
        
        let vc = TransactionEdit()
        vc.editData = moden
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
