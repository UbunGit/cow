//
//  ETFDetaiViewController.swift
//  Cow
//
//  Created by admin on 2021/8/27.
//

import UIKit

class ETFDetaiViewController: CViewController {
    @objc var code:String = ""
    @objc var name:String = ""
    @IBOutlet weak var collectionView: UICollectionView!
    lazy var naveView:KlineNavBarView = {
        let aview = KlineNavBarView.initWithNib()
        return aview
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        naveView.codeLab.text = code
        naveView.nameLab.text = name
        navigationItem.titleView = naveView
        configCollectionView()
    }

}
extension ETFDetaiViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func configCollectionView(){
        collectionView.register(UINib(nibName: "ETFDetaiKlineCell", bundle: nil), forCellWithReuseIdentifier: "ETFDetaiKlineCell")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ETFDetaiKlineCell", for: indexPath) as! ETFDetaiKlineCell
            cell.celldata.code = code
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.size.width, height: 300)
    }
    
    
}
