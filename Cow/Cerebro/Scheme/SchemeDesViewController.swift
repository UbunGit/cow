//
//  SchemeDesViewController.swift
//  Cow
//
//  Created by admin on 2021/11/4.
//

import UIKit
import Alamofire
class SchemeDesViewController: BaseViewController {
    
   

    var schemeId:Int = 0
    var selectDate = "20201020"
    var pools:[[String:Any]] = []
    var S_error:BaseError? = nil
    var exitId:Int? = nil
    var exitState:Int? = nil // 回测状态 0 默认 1运行中  2完成退出 3异常退出
    var cutdown = 5
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var refresh: UIButton = {
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        button.setImage(.init(systemName: "plus"), for: .normal)
        button.setBlockFor(.touchUpInside) {[weak self] _ in
            self?.exit()
        }
        return button
    }()
    
    lazy var settingBtn: UIButton = {
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        button.setImage(.init(systemName: "gearshape"), for: .normal)
        button.setBlockFor(.touchUpInside) {[weak self] _ in
        
        }
        return button
    }()
    
    // 添加
    lazy var refreshItem: UIBarButtonItem = {
        let mineItem = UIBarButtonItem.init(customView: refresh)
        return mineItem
    }()
    // 添加
    lazy var setingItem: UIBarButtonItem = {
        let mineItem = UIBarButtonItem.init(customView: settingBtn)
        return mineItem
    }()

    
    lazy var headrtView:CollectionHeaderView = {
        let view = CollectionHeaderView()
        view.backgroundColor = .red
        view.dataSource = ["推荐","预交易","成交单","回测曲线","分时收益","历史交易","选股池"]
        view.setBlockFor(.valueChanged) { _ in
            let value = view.value
            let indexpath = IndexPath.init(row: 0, section: value)
            print(value)
            if let _ = self.collectionView.cellForItem(at: indexpath) {
                self.collectionView.scrollToItem(at: indexpath, at: .top, animated: true)
            }else{
                self.collectionView.scrollToTop()
            }
        }
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItems = [refreshItem,setingItem]
        makeUI()
        loadData()
    }
  
    
    // 推荐列表
    lazy var recommendData: SchemeDesRecommendData = {
        let data = SchemeDesRecommendData()
        data.schemeId = self.schemeId
        data.loadData()
        data.valueChange = {
            self.collectionView.reloadSections(.init(integer: 0))
        }
        
        return data
    }()
    // 回测曲线
    lazy var yieldCurve:SchemeYieldCurve = {
        let data = SchemeYieldCurve()
        data.valueChange = {
            
            self.collectionView.reloadSections(.init(integer: cellType.yide.rawValue))
        }

        return data
    }()
    // 今日成交单
    lazy var contractNotes:SchemezContract = {
        let data = SchemezContract()
        data.valueChange = {
            self.collectionView.reloadSections(.init(integer: cellType.contract.rawValue))
        }
     
        return data
    }()
    // 历史成交单
    lazy var historyNotes:SchemeHistory = {
        let data = SchemeHistory()
        data.valueChange = {
            self.collectionView.reloadSections(.init(integer: cellType.history.rawValue))
        }
     
        return data
    }()
    // 股票池
    lazy var schemePoolData: SchemeDesPool = {
        let data = SchemeDesPool()
        data.valueChange = {
           
            self.collectionView.reloadSections(.init(integer: cellType.pool.rawValue))
        }

        return data
    }()
    
    // 收益时间轴
    lazy var timeYiedData:SchemeTimeYield = {
        let data = SchemeTimeYield()
        data.schemeId = schemeId
  
        return data
    }()
    // 预订单
    lazy var beforeDatas:SchemeBeforehand = {
        let data = SchemeBeforehand()
        data.schemeId = schemeId
        data.selectDate = selectDate
        data.valueChange = {
            self.collectionView.reloadSections(.init(integer: cellType.beforehand.rawValue))
        }
        return data
    }()
 
    
   
    
  
    // 更新全部数据
    func updateData(){
        recommendData.selectDate = selectDate
        recommendData.loadData()
        
        schemePoolData.loadData()
        
        yieldCurve.endDate = selectDate
        yieldCurve.begindate = "20160101"
        yieldCurve.pools = pools
        yieldCurve.loadData()
        
        contractNotes.selectDate = selectDate
        contractNotes.loadData()
        
        historyNotes.selectDate = selectDate
        historyNotes.loadData()
        
        timeYiedData.schemeId = schemeId
        timeYiedData.pools = pools
        
        beforeDatas.selectDate = selectDate
        beforeDatas.loadDate()
        
    }
   


}
/**
 data
 */

extension SchemeDesViewController{
    
    func exit(){
        self.refresh.beginrefresh()
        AF.scheme_exit(self.schemeId)
            .responseModel(Int.self) { result in
                switch result{
                case .success(let value):
                    self.exitId = value
                    NotificationCenter.default.addObserver(self, selector: #selector(self.globlaTimerDoit), name: NSNotification.Name("GloableTimer"), object: nil)
                case .failure(let err):
                    self.refresh.stoprefresh()
                    self.error(err)
                    
                }
            }

    }
    
   @objc func globlaTimerDoit(){
       if cutdown>0{
           cutdown-=1
           return
       }else{
           cutdown=5
       }
        guard let exid = exitId else{
            self.refresh.stoprefresh()
            self.view.error("exitId 不能为空")
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name("GloableTimer"), object: nil)
            return
        }
        if exitState == 2{
            self.refresh.stoprefresh()
            self.loadData()
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name("GloableTimer"), object: nil)
            return
        }
        if exitState == 3{
            self.refresh.stoprefresh()
            self.view.error("回测失败")
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name("GloableTimer"), object: nil)
            return
        }
        AF.scheme_status(exid)
            .responseModel([[String:Any]].self) { result in
                switch result{
                    
                case .success(let value):
                    let data = value.first
                    self.exitState = data?["state"].int() ?? 0
                    if self.exitState == 2{
                        self.refresh.stoprefresh()
                        self.loadData()
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("GloableTimer"), object: nil)
                    }
                    break
                case .failure(let err):
                    print("scheme_status error:\(err)")
                    break
                }
                
            }
        
    }

    
    func loadData(){
        self.view.loading()
        S_error = nil
        let queue = DispatchQueue(label: "eee",qos: .unspecified)
        let semaphore = DispatchSemaphore(value: 0)
        
        queue.async {
        AF.scheme_lastDate(self.schemeId)
            .responseModel([[String:Any]].self) { result in
                self.view.loadingDismiss()
                switch result{
                case .success(let value):
                    if let datedic = value.first{
                        self.selectDate = datedic["date"].string()
                        
                    }else{
                        self.S_error = BaseError(code: -1, msg: "获取最后交易日失败")
                    }
                    break
                case .failure(let err):
                    self.S_error = err
                }
                semaphore.signal()
            }
            semaphore.wait()
        }
        
        
        queue.async {
   
            AF.scheme_pool(self.schemeId).responseModel([[String:Any]].self) { result in
                switch result{
                case .success(let value):
                    self.pools = value
                    
                case .failure(let err):
                    self.S_error = err
                    
                }
                semaphore.signal()
                
            }
            semaphore.wait()
        }
       

        queue.async {
            self.downochldate(semaphore: semaphore)
            semaphore.wait()
        }
        queue.async {
            self.downback_trace(semaphore: semaphore)
            semaphore.wait()
        }
        queue.async {
            DispatchQueue.main.async {
                self.view.loadingDismiss()
                self.updateData()
            }
        }
        
       
    }
    
    func downochldate(semaphore:DispatchSemaphore){
        let group = DispatchGroup()
        if sm.isExistsTable("loc_ochl") == false{
            _ = sm.createTable("loc_ochl")
        }
     
        pools.forEach { item in
            group.enter()
            let code = item["code"].string()
            let end:String? = nil
            
            var begin:String? = nil
            if let data = sm.select(" select max(date) date from loc_ochl where code='\(code)' ").last{
                begin = data["date"].string()
            }
            AF.dailydata(code, type: item["type"].int(), begin: begin, end: end)
                .responseModel([[String:Any]].self) { result in
                    switch result{
                    case .success(let value):
                        if sm.mutableinster(table: "loc_ochl", column: ["code","date","open","close","low","high","vol"], datas: value) == false{
                            
                        }
                        break
                    case .failure( let err ):
                        self.S_error = err
                        break
                    }
                    group.leave()
                    
                }
        }
        group.notify(queue: .main) {
           
            semaphore.signal()
            
        }
        
    }
    func downback_trace(semaphore:DispatchSemaphore){
   
        if sm.isExistsTable("back_trade") == false{
            _ = sm.createTable("back_trade")
        }
        let sql = " delete FROM back_trade where scheme_id = '\(schemeId)' "
        _ =  sm.delete(sql)
        
        
        AF.back_trade(schemeId: schemeId)
            .responseModel([[String:Any]].self) { result in
              
                switch result{
                case .success(let value):
                    if sm.mutableinster(table: "back_trade", column: ["id","scheme_id","date","type","code","price","dir","count","sid"], datas: value) == true{
                       
                    }else{
                        self.S_error = BaseError(code: -1, msg: "插入数据失败")
                    }
                    break
                case .failure( let err ):
                    self.S_error = err
                }
                semaphore.signal()
                
            }
        
    }
}


extension SchemeDesViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    enum cellType:Int{
        case recommend=0    // 推荐
        case beforehand = 1 // 预买
        case contract = 2   // 成交
        case yide = 3   // 收益曲线
        case yidetime = 4   // 分时收益
        case history = 5   // 历史
        case pool = 6   // 历史
    }
    func makeUI(){
        title = "策略评估"
        collectionView.register(CollectionHeaderCell.self, forCellWithReuseIdentifier: "CollectionHeaderCell")
        collectionView.register(UINib(nibName: "SchemeDesRecommendCell", bundle: nil), forCellWithReuseIdentifier: "SchemeDesRecommendCell")
        collectionView.register(UINib(nibName: "SchemeDesPoolCell", bundle: nil), forCellWithReuseIdentifier: "SchemeDesPoolCell")
        collectionView.register(UINib(nibName: "SchemeYieldCurveCell", bundle: nil), forCellWithReuseIdentifier: "SchemeYieldCurveCell")
        collectionView.register(UINib(nibName: "SchemeHistoryCell", bundle: nil), forCellWithReuseIdentifier: "SchemeHistoryCell")
        collectionView.register(SchemeTimeYieldCell.self, forCellWithReuseIdentifier: "SchemeTimeYieldCell")
        
        
        
        collectionView.register(UINib(nibName: "SchemeDesRecommendHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SchemeDesRecommendHeader")
        collectionView.register(SchemeYieldCurveHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SchemeYieldCurveHeader")
        collectionView.register(UINib(nibName: "HTCollectionBaseHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HTCollectionBaseHeaderView")
        collectionView.register(UINib(nibName: "SchemeHistoryHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SchemeHistoryHeader")
        
        collectionView.register(UICollectionEmptyFootView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "UICollectionEmptyFootView")
        
        
        view.addSubview(headrtView)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headrtView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(collectionView.snp.top).offset(-1)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section{
        case cellType.recommend.rawValue: // 推荐
            return recommendData.datas.count
        case cellType.beforehand.rawValue: // 预买卖
            return beforeDatas.datas.count
        case cellType.contract.rawValue://成交
            return contractNotes.datas.count
        case cellType.yide.rawValue:  // 收益曲线
            return 1
        case cellType.yidetime.rawValue:  // 分时收益
            return 1
        case cellType.history.rawValue:
            return historyNotes.datas.count
            
        case cellType.pool.rawValue:
            return schemePoolData.datas.count
   
        default:
            return 0
        }
        

        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section{
           
        case cellType.recommend.rawValue: // 推荐
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SchemeDesRecommendCell", for: indexPath) as!  SchemeDesRecommendCell
            let celldata = recommendData.datas[indexPath.row]
            let isbuy = (celldata["isgo"]==nil) ? "" : "/未成"
            let dir = celldata["dir"].int()==0
            let code = celldata["code"].string()
            let name = celldata["name"].string()
            let price = sm.closePrice(code: code, date: recommendData.selectDate.string())
            let dirstr = "\(dir ? "买入" : "卖出") \(isbuy)"
            cell.nameLab.text = name
            cell.codeLab.text = code
            cell.priceLab.text = price.price()
            cell.dirLab.text = dirstr
            cell.dirLab.textColor = dir ? .up : .down
            cell.remarkView.backgroundColor = dir ? .up : .down
            return cell
        case cellType.beforehand.rawValue: // 预交易
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SchemeDesRecommendCell", for: indexPath) as!  SchemeDesRecommendCell
            let celldata = beforeDatas.datas[indexPath.row]
            let isbuy = (celldata["isgo"]==nil) ? "" : "/未成"
            let dir = celldata["dir"].int()==0
            let code = celldata["code"].string()
            let name = celldata["name"].string()
            let price = sm.closePrice(code: code, date: recommendData.selectDate.string())
            let dirstr = "\(dir ? "买入" : "卖出") \(isbuy)"
            cell.nameLab.text = name
            cell.codeLab.text = code
            cell.priceLab.text = price.price()
            cell.dirLab.text = dirstr
            cell.dirLab.textColor = dir ? .up : .down
            cell.remarkView.backgroundColor = dir ?  .up : .down
            return cell
       
        case cellType.yide.rawValue: // 收益曲线
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SchemeYieldCurveCell", for: indexPath) as!  SchemeYieldCurveCell
            cell.celldata = yieldCurve
            cell.updateUI()
            return cell
          
        case cellType.contract.rawValue: // 成交
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SchemeDesRecommendCell", for: indexPath) as!  SchemeDesRecommendCell
            let celldata = contractNotes.datas[indexPath.row]
            let dir = celldata["dir"].int()==0
            
            let code = celldata["code"].string()
            let name = celldata["name"].string()
            let price = celldata["price"].price()
            let dirstr = (celldata["dir"].int()==0) ? "买入" : "卖出"
            cell.nameLab.text = name
            cell.codeLab.text = code
            cell.priceLab.text = price
            cell.dirLab.text = dirstr
            cell.dirLab.textColor = dir ? .up : .down
            cell.remarkView.backgroundColor = dir ? .up : .down
            return cell
        case cellType.history.rawValue: // 历史
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SchemeHistoryCell", for: indexPath) as!  SchemeHistoryCell
            let celldata = historyNotes.datas[indexPath.row]
            let date = celldata["date"].string()
            let sdate = celldata["sdate"].string()
            let code = celldata["code"].string()
            let name = celldata["name"].string()
            let bprice = celldata["buyPrice"].price()
            let sprice = celldata["sellPrice"].price()
            let yied = celldata["yied"].price()
            cell.nameLab.text = name
            cell.codeLab.text = code
            cell.buydateLab.text = date
            cell.sellDateLab.text = sdate
            cell.buyPriceLab.text = bprice
            cell.sellPriceLab.text = sprice
            cell.yiedLab.text = yied
           
            return cell
            
          
            
        case cellType.pool.rawValue: // 股票池
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SchemeDesPoolCell", for: indexPath) as!  SchemeDesPoolCell
            cell.celldata = schemePoolData.datas[indexPath.row]
            cell.backgroundColor = UIColor.random().alpha(0.2)
            return cell
      
        case cellType.yidetime.rawValue: // 分时收益
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SchemeTimeYieldCell", for: indexPath) as!  SchemeTimeYieldCell
            cell.celldata = timeYiedData;
            cell.loadData()
            cell.backgroundColor = UIColor.random().alpha(0.2)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionHeaderCell", for: indexPath) as!  CollectionHeaderCell
            cell.titleLab.text = "\(indexPath.section)"
            cell.backgroundColor = .random()
            return cell
            
        }
      
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
       
        switch indexPath.section{
        case cellType.recommend.rawValue: // 推荐
            return .init(width: collectionView.width-16, height: 44)
        case cellType.beforehand.rawValue:// 预买
            return .init(width: collectionView.width-16, height: 44)
        case cellType.contract.rawValue:// 成交
            return .init(width: collectionView.width-16, height: 44)
        case cellType.yide.rawValue: // 收益曲线
            return .init(width: collectionView.width-16, height: 300)
        case cellType.yidetime.rawValue:// 分时收益
            return .init(width: collectionView.width-16, height: 300)
        case cellType.history.rawValue:// 历史
            return .init(width: collectionView.width-16, height: 44)
        case cellType.pool.rawValue:// 股票池
            return .init(width: (collectionView.width-16)/3, height: 62)
        
        default:
            return .init(width: collectionView.width-16, height: 220)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
 
        switch section{
        case cellType.recommend.rawValue:// 推荐
            return .init(width: collectionView.width-18, height: 84)
        case cellType.beforehand.rawValue:// 预买
            return .init(width: collectionView.width-18, height: 84)
        case cellType.contract.rawValue: // 成交
            return .init(width: collectionView.width-18, height: 84)
        case cellType.yide.rawValue:// 收益曲线
            return .init(width: collectionView.width-18, height: 44)
        case cellType.yidetime.rawValue: // 分时收益
            return .init(width: collectionView.width-18, height: 44)
        case cellType.history.rawValue: // 历史
            return .init(width: collectionView.width-18, height: 84)
        case cellType.pool.rawValue:// 股票池
            return .init(width: collectionView.width-18, height: 44)
        default:
            return .zero
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader{
            
          
            switch indexPath.section{
            case cellType.recommend.rawValue: //推荐
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SchemeDesRecommendHeader", for: indexPath) as! SchemeDesRecommendHeader
                
                header.titleLab.text = "今日推荐"
                header.valueLab.text = recommendData.selectDate
                header.settingBtn.setBlockFor(.touchUpInside) { _ in
                    self.selectDate(selectDate:self.recommendData.selectDate?.date("yyyyMMdd") ) { value in
                        self.recommendData.selectDate = value.toString("yyyyMMdd")
                        self.recommendData.loadData()
                    }
                }
                
                switch recommendData.state{
                case 2:
                    header.settingBtn.beginrefresh()
                default:
                    header.settingBtn.layer.removeAllAnimations()
                }
                
                return header
            case cellType.beforehand.rawValue: //预交易
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SchemeDesRecommendHeader", for: indexPath) as! SchemeDesRecommendHeader
                header.titleLab.text = "预交易"
                header.valueLab.text = beforeDatas.selectDate
                if beforeDatas.loading{
                    header.settingBtn.beginrefresh()
                }else{
                    header.settingBtn.layer.removeAllAnimations()
                }
                header.settingBtn.setBlockFor(.touchUpInside) { _ in
                    self.selectDate(selectDate:self.recommendData.selectDate?.date("yyyyMMdd") ) { value in
                        self.beforeDatas.selectDate = value.toString("yyyyMMdd")
                        self.beforeDatas.loadDate()
                    }
                }
                return header
        
            case cellType.yide.rawValue: //回测曲线
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SchemeYieldCurveHeader", for: indexPath) as! SchemeYieldCurveHeader
                header.titleLab.text = "回测曲线"
                header.beginDatePicker.date = yieldCurve.begindate?.date("yyyyMMdd") ?? Date()
                header.endDatePicker.date = yieldCurve.endDate?.date("yyyyMMdd") ?? Date()
                header.settingbtn.setBlockFor(.touchUpInside) { _ in
                    self.yieldCurve.begindate = header.beginDatePicker.date.toString("yyyyMMdd")
                    self.yieldCurve.endDate = header.endDatePicker.date.toString("yyyyMMdd")
                    self.yieldCurve.loadData()
                }
               
                return header
               
            case cellType.contract.rawValue: //成交
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SchemeDesRecommendHeader", for: indexPath) as! SchemeDesRecommendHeader
                header.titleLab.text = "今日成交"
                header.valueLab.text = contractNotes.selectDate
                header.settingBtn.setBlockFor(.touchUpInside) { _ in
                    self.selectDate(selectDate: self.contractNotes.selectDate.date("yyyyMMdd")) { value in
                        self.contractNotes.selectDate = value.toString("yyyyMMdd")
                        self.contractNotes.loadData()
                    }
                }
                header.settingBtn.layer.removeAllAnimations()
                return header
          
            case cellType.history.rawValue: //历史成交
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SchemeHistoryHeader", for: indexPath) as! SchemeHistoryHeader
//                header.titleLab.text = "历史成交"
//                header.valueLab.text = nil
//                header.settingBtn.layer.removeAllAnimations()
                return header
            case cellType.yidetime.rawValue: //分时收益
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HTCollectionBaseHeaderView", for: indexPath) as! HTCollectionBaseHeaderView
                header.titleLab.text = "分时收益"
                return header
       
            case cellType.pool.rawValue: //选股池
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HTCollectionBaseHeaderView", for: indexPath) as! HTCollectionBaseHeaderView
                header.titleLab.text = "选股池"
                header.moreBtn.setBlockFor(.touchUpInside) { _ in
                    let vc = SchemeSettingPoolVC()
                    vc.schemeId = self.schemeId
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                return header
            default:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HTCollectionBaseHeaderView", for: indexPath) as! HTCollectionBaseHeaderView
                header.titleLab.text = "\(indexPath.section)"
               
                
                return header
            }
        }else if kind == UICollectionView.elementKindSectionFooter{
            switch indexPath.section{

            case cellType.recommend.rawValue: //今日推荐
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "UICollectionEmptyFootView", for: indexPath) as! UICollectionEmptyFootView
                return header
            
            default:
                return UICollectionReusableView()
            }
        }
        return UICollectionReusableView()
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        switch section{
        case cellType.recommend.rawValue:
            return  recommendData.datas.count<=0 ? .init(width: collectionView.width, height: 44) : .zero
        
        default:
            return .zero
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 4, left: 8, bottom: 4, right: 8)
    }
    
    
  
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let indexpath = collectionView.indexPathsForVisibleItems.min(by: {
            $0.section<$1.section
        }){
            headrtView.value = indexpath.section
        }
    }
   
 
    
   
    
}

