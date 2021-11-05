//
//  SchemeDesViewController.swift
//  Cow
//
//  Created by admin on 2021/11/4.
//

import UIKit

class SchemeDesViewController: BaseViewController {

    var schemeId:Int = 0
    
    @IBOutlet weak var collectionView: UICollectionView!
    lazy var recommendData: SchemeDesRecommendData = {
        let data = SchemeDesRecommendData()
        data.valueChange = {
            self.collectionView.reloadData()
        }
        data.loadData()
        return data
    }()
    lazy var schemePoolData: SchemeDesPool = {
        let data = SchemeDesPool()
        data.valueChange = {
            self.collectionView.reloadData()
        }
        data.loadData()
        return data
    }()
 
    
    lazy var headrtView:CollectionHeaderView = {
        let view = CollectionHeaderView()
        view.backgroundColor = .red
        view.dataSource = ["今日推荐","回测曲线","3","3","3","3","3","选股池"]
        view.setBlockFor(.valueChanged) { _ in
            let value = view.value
            self.collectionView.scrollToItem(at: .init(row: 0, section: value), at: .top, animated: true)
        }
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    func makeUI(){
        title = "策略评估"
        collectionView.register(CollectionHeaderCell.self, forCellWithReuseIdentifier: "CollectionHeaderCell")
        collectionView.register(UINib(nibName: "SchemeDesRecommendCell", bundle: nil), forCellWithReuseIdentifier: "SchemeDesRecommendCell")
        collectionView.register(UINib(nibName: "SchemeDesPoolCell", bundle: nil), forCellWithReuseIdentifier: "SchemeDesPoolCell")
        
        collectionView.register(UINib(nibName: "SchemeDesRecommendHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SchemeDesRecommendHeader")
        collectionView.register(UINib(nibName: "HTCollectionBaseHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HTCollectionBaseHeaderView")
        
        
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
        case 5:
            return schemePoolData.datas.count
        default:
            return 1
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section{
        case 0:
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SchemeDesRecommendCell", for: indexPath) as!  SchemeDesRecommendCell
            cell.celldata = recommendData.datas[indexPath.row]
            return cell
        case 5:
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
        case 5:
            return .init(width: (collectionView.width/2)-16, height: 62)
        default:
            return .init(width: collectionView.width, height: 220)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section{
        case 0:
            return .init(width: collectionView.width, height: 84)
        case 5:
            return .init(width: collectionView.width, height: 44)
        default:
            return .zero
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader{
            switch indexPath.section{
            case 0: //今日推荐
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SchemeDesRecommendHeader", for: indexPath)
                return header
            case 5: //选股池
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HTCollectionBaseHeaderView", for: indexPath) as! HTCollectionBaseHeaderView
                header.titleLab.text = "选股池"
                
                return header
            default:
                return UICollectionReusableView()
            }
        }
        return UICollectionReusableView()
        
        
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

