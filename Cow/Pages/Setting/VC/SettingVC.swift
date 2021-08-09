//
//  DatamanageVC.swift
//  Cow
//
//  Created by admin on 2021/8/9.
//

import UIKit

class SettingVC: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    lazy var grids: [DataHandleModel] = {
        let grids = [
            DataHandleModel.init(
                name: "股票列表",
                icon: "🐶",
                handle: {
                    self.mb_push("Cow.StockBasicListVC", params: [:])
                }
            ),
            DataHandleModel.init(
                name: "ETF列表",
                icon: "🐱",
                handle: {
                    
                }
            ),
            DataHandleModel.init(
                name: "可转债",
                icon: "🐭",
                handle: {
                    
                }
            ),
            DataHandleModel.init(
                name: "指数",
                icon: "🐹",
                handle: {
                    
                }
            ),
            DataHandleModel.init(
                name: "板块",
                icon: "🐰",
                handle: {
                    
                }
            )
        ]
        return grids
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configCollectionView()
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
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return grids.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SettingHeaderCollectionViewCell", for: indexPath)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewGridCell", for: indexPath) as! CollectionViewGridCell
            cell.imageLab.text = grids[indexPath.row].icon;
            cell.titleLab.text = grids[indexPath.row].name
            cell.imageView.image = UIImage(systemName: grids[indexPath.row].icon)
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
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: collectionView.bounds.size.width, height: 100)
        case 1:
            return CGSize(width: ((collectionView.bounds.size.width-16)/5)-1, height: (collectionView.bounds.size.width-16)/5 + 20 )
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            return 
        case 1:
            grids[indexPath.row].handle()
        default:
            return
        }
    }
    
    
}
