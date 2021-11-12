//
//  StockBasicListVC.swift
//  Cow
//
//  Created by admin on 2021/8/9.
//

import UIKit
import Magicbox
import HandyJSON
import MJRefresh
import Alamofire


class StockBasicListModel: HandyJSON {
    
    var delegate:BasetModelDelegate?
    var range = NSRange(location: 0, length: 20)
    var keyword:String? = nil
    struct Stroe:HandyJSON{
        var name:String = ""
        var code:String = ""
        var area:String = ""
        var industry:String = ""
        var follow:Bool = false
        var market:String = ""
        var changeTime:String = "\(Date().toString("yyyy-MM-dd"))"

    }
    var stroes:[Stroe] = []
    required init() {
        
    }
    func updateStore()  {
       
        AF.af_select(sm.select_stockbasic_follow(keyword:keyword,limmit:range)) { result in
          
            switch result{
            case .success(let value):
                guard let datas = [Stroe].deserialize(from: value) else {
                    return
                }
                var list:[Stroe] = []
                for item in datas {
                    if let d = item{
                        list.append(d)
                    }
                }
                if self.range.location == 0 {
                    self.stroes = list
                }else{
                    self.stroes += list
                }
                self.delegate?.updateUI()
                
            case .failure(let err):
                self.delegate?.view.error(err.localizedDescription)
            }
        }
      
    }
    
    func follow(row:Int)  {
        let store = stroes[row]
        if let user = Global.share.user{
            let sql = sm.insterStockfollow(code: store.code, userId: user.userId)
            AF.af_update(sql) { result in
                switch result{
                case .success(_):
                    self.stroes[row].follow = true
                    self.delegate?.updateUI()
                case .failure(let err):
                    self.delegate?.view.error(err.localizedDescription)
                }
            }
        }
        else{
            delegate?.present(loginViewController(), animated: true, completion: nil)
            
        }
      
    }
}

class StockBasicListVC: BaseViewController {

    var selectClosure:((StockBasicListModel.Stroe)->())?
    
    lazy var pageData: StockBasicListModel = {
        let pageData = StockBasicListModel()
        pageData.delegate = self
        return pageData
    }()
    
    lazy var tableHeadView:BaseTableSearchHeaderView = {
        let header = BaseTableSearchHeaderView.initWithNib()
        header.frame = .init(x: 0, y: 0, width: KWidth, height: 44)
        header.inputTF.setBlockFor(.editingChanged) { textField in
            guard let tf = textField as? UITextField else{
                return
            }
            self.pageData.range.location = 0
            self.pageData.keyword = tf.text
            self.pageData.updateStore()
        }
        return header
   
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "股票列表"
        configTableview()
        pageData.updateStore()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    override func updateUI() {
        tableView.mj_footer?.endRefreshing()
        tableView.mj_header?.endRefreshing()
        tableView.reloadData()
    }
}
extension StockBasicListVC:UITableViewDelegate,UITableViewDataSource{
    
    func configTableview()  {
        tableView.tableHeaderView = tableHeadView
        tableView.estimatedRowHeight = 60
        tableView.register(UINib(nibName: "StockBasicListCell", bundle: nil), forCellReuseIdentifier: "StockBasicListCell")
        tableView.mj_header = MJRefreshGifHeader(refreshingBlock: {
            self.pageData.range.location = 1
            self.pageData.updateStore()
        })
        tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
       
            self.pageData.range.location += 1
            self.pageData.updateStore()
        })
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageData.stroes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockBasicListCell", for: indexPath) as! StockBasicListCell
        cell.celldata = pageData.stroes[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let select = selectClosure {
            
            self.dismiss(animated: true) {
                select(self.pageData.stroes[indexPath.row])
            }
        }
        
    }

    
    // 右侧按钮自定义
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let archiveAction = UIContextualAction(style: .normal, title: "关注") { [self] (action, view, finished) in
            pageData.follow(row: indexPath.row)
            pageData.stroes[indexPath.row].follow = true
            tableView.reloadRow(at: indexPath, with: .automatic)
            
            finished(true)
        }
        
        
        return UISwipeActionsConfiguration(actions: [ archiveAction])
    }
    
    
}

