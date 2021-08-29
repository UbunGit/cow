//
//  ETFDetaiViewController.swift
//  Cow
//
//  Created by admin on 2021/8/27.
//

import UIKit

class ETFDetaiViewController: BaseViewController, ETFDetaiModenDelegate {
    @objc var code:String = ""
    @objc var name:String = ""
    @IBOutlet weak var collectionView: UICollectionView!
    var detaiData = ETFDetaiModen()
   
    lazy var naveView:KlineNavBarView = {
        let aview = KlineNavBarView.initWithNib()
        return aview
    }()
    // 消息
    lazy var newbutton: UIButton = {
        let button = UIButton()
        button.mb_radius = 18
        button.setTitleColor(UIColor(named: "Background 5"), for: .normal)
        button.mb_borderColor = UIColor(named: "Background 3")
        button.mb_borderWidth = 1
        button.titleEdgeInsets = .init(top: 4, left: 8, bottom: 4, right: 8)
        button.setTitle("🔔", for: .normal)
        button.addTarget(self, action: #selector(settingDoit), for: .touchUpInside)
        return button
    }()
    
    // 消息
    lazy var newItem: UIBarButtonItem = {
      
        let newItem = UIBarButtonItem.init(customView: newbutton)
        
        return newItem
    }()
    @objc func settingDoit(){
        let setvc = ETFDetaiSettingVC()
        setvc.setdata = detaiData
        self.present(setvc, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        naveView.codeLab.text = code
        naveView.nameLab.text = name
        navigationItem.titleView = naveView
        navigationItem.rightBarButtonItems = [newItem]
        configCollectionView()
        detaiData.delegate = self
        detaiData.code = code
    }
    override func updateUI() {
        newbutton.setTitle("\(detaiData.speed)", for: .normal)
        collectionView.reloadData()
    }

}
extension ETFDetaiViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func configCollectionView(){
        collectionView.register(UINib(nibName: "ETFDetaiKlineCell", bundle: nil), forCellWithReuseIdentifier: "ETFDetaiKlineCell")
        collectionView.register(UINib(nibName: "ETFKirogiSignalCell", bundle: nil), forCellWithReuseIdentifier: "ETFKirogiSignalCell")
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ETFDetaiKlineCell", for: indexPath) as! ETFDetaiKlineCell
            cell.celldata = detaiData
            cell.updateUI()
            cell.updateTopView()
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ETFKirogiSignalCell", for: indexPath) as!  ETFKirogiSignalCell
            cell.celldata = detaiData
            cell.updateUI()
            return cell
           
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.size.width, height: 300)
    }
    
    
}


