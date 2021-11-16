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
    var selectDate = "20201020" //NSDate.now.toString("yyyyMMdd")
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var refresh: UIButton = {
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        button.setImage(.init(systemName: "plus"), for: .normal)
        button.setBlockFor(.touchUpInside) {[weak self] _ in
            AF.scheme_exit(self?.schemeId ?? 0)
                .responseModel(String.self) { result in
                    
                }
        }
        return button
    }()
    
    // 添加
    lazy var refreshItem: UIBarButtonItem = {
        let mineItem = UIBarButtonItem.init(customView: refresh)
        return mineItem
    }()
    // 推荐列表
    lazy var recommendData: SchemeDesRecommendData = {
        let data = SchemeDesRecommendData()
        data.schemeId = self.schemeId
        data.loadData()
        data.valueChange = {
            self.collectionView.reloadData()
//            self.collectionView.reloadItems(at: [.init(row: 0, section: 0)])
        }
        
        return data
    }()
    // 股票池
    lazy var schemePoolData: SchemeDesPool = {
        let data = SchemeDesPool()
        data.valueChange = {
            self.collectionView.reloadData()
//            self.collectionView.reloadItems(at: [.init(row: 0, section: 5)])
        }
        data.loadData()
        return data
    }()
    // 回测曲线
    lazy var yieldCurve:SchemeYieldCurve = {
        let data = SchemeYieldCurve()
        data.valueChange = {
            self.collectionView.reloadData()
//            self.collectionView.reloadItems(at: [.init(row: 0, section: 1)])
        }
        
        data.loadData()
        return data
    }()
    // 今日成交
    var contractNotes:[[String:Any]] {
        let sql = """
        SELECT * FROM back_trade
        WHERE scheme_id = \(schemeId) AND date='\(selectDate)'
        """
        return sm.select(sql)
    }
    // 历史成交
    var historyNotes:[[String:Any]] {
        let sql = """
        SELECT * FROM back_trade
        WHERE scheme_id = \(schemeId) AND date<='\(selectDate)'
        """
        return sm.select(sql)
    }
    
  
 
    
    lazy var headrtView:CollectionHeaderView = {
        let view = CollectionHeaderView()
        view.backgroundColor = .red
        view.dataSource = ["今日推荐","回测曲线","今日成交","历史交易","选股池"]
        view.setBlockFor(.valueChanged) { _ in
            let value = view.value
            let indexpath = IndexPath.init(row: 0, section: value)
            if let _ = self.collectionView.cellForItem(at: indexpath) {
                self.collectionView.scrollToItem(at: indexpath, at: .top, animated: true)
            }
        }
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItems = [refreshItem]
        makeUI()
    }
    func makeUI(){
        title = "策略评估"
        collectionView.register(CollectionHeaderCell.self, forCellWithReuseIdentifier: "CollectionHeaderCell")
        collectionView.register(UINib(nibName: "SchemeDesRecommendCell", bundle: nil), forCellWithReuseIdentifier: "SchemeDesRecommendCell")
        collectionView.register(UINib(nibName: "SchemeDesPoolCell", bundle: nil), forCellWithReuseIdentifier: "SchemeDesPoolCell")
        collectionView.register(UINib(nibName: "SchemeYieldCurveCell", bundle: nil), forCellWithReuseIdentifier: "SchemeYieldCurveCell")
        
        collectionView.register(UINib(nibName: "SchemeDesRecommendHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SchemeDesRecommendHeader")
        collectionView.register(UINib(nibName: "HTCollectionBaseHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HTCollectionBaseHeaderView")
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


}


extension SchemeDesViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section{
        case 0:
            return recommendData.datas.count
        case 1:
            return 1
        case 2:
            return contractNotes.count
        case 3:
            return historyNotes.count
            
        case 4:
            return schemePoolData.datas.count
        default:
            return 0
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section{
        case 0:
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SchemeDesRecommendCell", for: indexPath) as!  SchemeDesRecommendCell
            let celldata = recommendData.datas[indexPath.row]
            let dir = (celldata["dir"].int()==0) ? "买入" : "卖出"
            let code = celldata["code"].string()
            let name = celldata["name"].string()
            let price = celldata["price"].price()
            cell.nameLab.text = name
            cell.codeLab.text = code
            cell.priceLab.text = price
            cell.dirLab.text = dir
            return cell
        case 1:
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SchemeYieldCurveCell", for: indexPath) as!  SchemeYieldCurveCell
            cell.celldata = yieldCurve
            return cell
        case 2:
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SchemeDesRecommendCell", for: indexPath) as!  SchemeDesRecommendCell
            let celldata = contractNotes[indexPath.row]
            let dir = (celldata["dir"].int()==0) ? "买入" : "卖出"
            let code = celldata["code"].string()
            let name = celldata["name"].string()
            let price = celldata["price"].price()
            cell.nameLab.text = name
            cell.codeLab.text = code
            cell.priceLab.text = price
            cell.dirLab.text = dir
            return cell
        case 3:
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SchemeDesRecommendCell", for: indexPath) as!  SchemeDesRecommendCell
            let celldata = historyNotes[indexPath.row]
            let date = celldata["date"].string()
            let dir = (celldata["dir"].int()==0) ? "买入\n\(date)" : "卖出\n\(date)"
            let code = celldata["code"].string()
            let name = celldata["name"].string()
            let price = celldata["price"].price()
            cell.nameLab.text = name
            cell.codeLab.text = code
            cell.priceLab.text = price
            cell.dirLab.text = dir
            cell.dirLab.textColor = (celldata["dir"].int()==0) ? .red : .green
            return cell
            
      
            
        case 4:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SchemeDesPoolCell", for: indexPath) as!  SchemeDesPoolCell
            cell.celldata = schemePoolData.datas[indexPath.row]
            cell.backgroundColor = UIColor.doraemon_random().alpha(0.2)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionHeaderCell", for: indexPath) as!  CollectionHeaderCell
            cell.titleLab.text = "\(indexPath.section)"
            cell.backgroundColor = .doraemon_random()
            return cell
            
        }
      
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section{
        case 0:
            return .init(width: collectionView.width, height: 44)
        case 1:
            return .init(width: collectionView.width, height: 300)
        case 2:
            return .init(width: collectionView.width, height: 44)
        case 3:
            return .init(width: collectionView.width, height: 44)
        case 4:
            return .init(width: (collectionView.width/2)-16, height: 62)
        default:
            return .init(width: collectionView.width, height: 220)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section{
        case 0:
            return .init(width: collectionView.width, height: 84)
        case 1:
            return .init(width: collectionView.width, height: 44)
        case 2:
            return .init(width: collectionView.width, height: 84)
        case 3:
            return .init(width: collectionView.width, height: 84)
        case 4:
            return .init(width: collectionView.width, height: 44)
        default:
            return .zero
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader{
            switch indexPath.section{
            case 0: //今日推荐
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SchemeDesRecommendHeader", for: indexPath) as! SchemeDesRecommendHeader
                
                header.titleLab.text = "今日推荐"
                header.valueLab.text = recommendData.selectDate
                header.settingBtn.setBlockFor(.touchUpInside) { _ in
                    self.selectDate { value in
                        self.recommendData.selectDate = value.toString("yyyyMMdd")
                        self.recommendData.loadData()
                    }
                }
                return header
            case 1: //回测曲线
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HTCollectionBaseHeaderView", for: indexPath) as! HTCollectionBaseHeaderView
                header.titleLab.text = "回测曲线"
                
                return header
            case 2: //今日成交
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SchemeDesRecommendHeader", for: indexPath) as! SchemeDesRecommendHeader
                header.titleLab.text = "今日成交"
                header.valueLab.text = selectDate
                return header
            case 3: //历史成交
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SchemeDesRecommendHeader", for: indexPath) as! SchemeDesRecommendHeader
                header.titleLab.text = "历史成交"
                header.valueLab.text = nil
                return header
            case 4: //选股池
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HTCollectionBaseHeaderView", for: indexPath) as! HTCollectionBaseHeaderView
                header.titleLab.text = "选股池"
                header.moreBtn.setBlockFor(.touchUpInside) { _ in
                    let vc = SchemeSettingPoolVC()
                    vc.schemeId = self.schemeId
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                return header
            default:
                return UICollectionReusableView()
            }
        }else if kind == UICollectionView.elementKindSectionFooter{
            switch indexPath.section{
            case 0: //今日推荐
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
        case 0:
            return  recommendData.datas.count<=0 ? .init(width: collectionView.width, height: 44) : .zero
        
        default:
            return .zero
        }
    }
    
    
  
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let indexpath = collectionView.indexPathForItem(at: scrollView.contentOffset){
            headrtView.value = indexpath.section
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 4, left: 8, bottom: 4, right: 8)
    }
 
    
   
    
}

