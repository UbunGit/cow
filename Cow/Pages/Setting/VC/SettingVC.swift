//
//  DatamanageVC.swift
//  Cow
//
//  Created by admin on 2021/8/9.
//

import UIKit
import Magicbox
import Alamofire

class SettingVC: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    lazy var downGrids: [DataHandleModel] = {
        let grids = [
            DataHandleModel.init(
                name: "股票列表",
                icon: "eurosign.circle",
                handle: {
                    self.mb_push("Cow.StockBasicListVC", params: [:])
                }
            ),
            DataHandleModel.init(
                name: "ETF列表",
                icon: "dongsign.square",
                handle: {
                    
                    self.mb_push("Cow.ETFBaseListVC", params: [:])
                }
            ),
            DataHandleModel.init(
                name: "可转债",
                icon: "tengesign.circle",
                handle: {
                   
                }
            ),
            DataHandleModel.init(
                name: "指数",
                icon: "kipsign.circle",
                handle: {
                    
                }
            ),
            DataHandleModel.init(
                name: "板块",
                icon: "wonsign.square",
                handle: {
                    
                }
            )
           
        ]
        return grids
    }()
    lazy var tableGrids: [DataHandleModel] = {
        let grids = [
            DataHandleModel.init(
                name: "表管理",
                icon: "perspective",
                handle: {
                    self.mb_push("Cow.SQLTableListVC", params: [:])
                }
            ),
            DataHandleModel.init(
                name: "策略模版",
                icon: "slider.horizontal.3",
                handle: {
                    self.mb_push("Cow.SchemeTemplateListVC", params: [:])
                }
            ),
           
        ]
        return grids
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
}

extension SettingVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func configCollectionView()  {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        collectionView.backgroundColor = .clear
        layout.minimumInteritemSpacing = 0.01
        collectionView.register(UINib(nibName: "SettingHeaderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SettingHeaderCollectionViewCell")
        collectionView.register(UINib(nibName: "CollectionViewGridCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewGridCell")
        
        
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return downGrids.count
        case 2:
            return tableGrids.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SettingHeaderCollectionViewCell", for: indexPath)
            cell.updateUI()
          
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewGridCell", for: indexPath) as! CollectionViewGridCell
      
            cell.titleLab.text = downGrids[indexPath.row].name
            cell.imageView.image = UIImage(systemName: downGrids[indexPath.row].icon)
            cell.mb_borderColor = .white
            cell.mb_borderWidth = 1
            cell.mb_radius = 4
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewGridCell", for: indexPath) as! CollectionViewGridCell
  
            cell.titleLab.text = tableGrids[indexPath.row].name
            cell.imageView.image = UIImage(systemName: tableGrids[indexPath.row].icon)
            cell.mb_borderColor = .white
            cell.mb_borderWidth = 1
            cell.mb_radius = 4
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        case 1:
            return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        case 2:
            return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: collectionView.bounds.size.width, height: 100)
        case 1:
            return CGSize(width: ((collectionView.bounds.size.width-16)/5)-1, height: (collectionView.bounds.size.width-16)/5  )
        case 2:
            return CGSize(width: ((collectionView.bounds.size.width-16)/5)-1, height: (collectionView.bounds.size.width-16)/5  )
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            needLogin()
            return 
        case 1:
            downGrids[indexPath.row].handle()
        case 2:
            tableGrids[indexPath.row].handle()
        default:
            return
        }
    }
    
    
}
