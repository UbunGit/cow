//
//  HomeViewController.swift
//  Cow
//
//  Created by admin on 2021/8/4.
//

import UIKit
import Magicbox
import SnapKit
import YYKit
class HomeViewController: BaseViewController {

    @IBOutlet weak var collecttionView: UICollectionView!
    lazy var minebtn: UIButton = {
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        button.setTitle("🐂", for: .normal)
        button.mb_radius = 18
        button.setTitleColor(UIColor(named: "Background 5"), for: .normal)
        button.mb_borderColor = UIColor(named: "Background 3")
        button.mb_borderWidth = 1
        button.titleEdgeInsets = .init(top: 4, left: 8, bottom: 4, right: 8)
        button.addTarget(self, action: #selector(userInfo), for: .touchUpInside)
        return button
    }()

    // 我
    lazy var mineItem: UIBarButtonItem = {

        let mineItem = UIBarButtonItem.init(customView: minebtn)
       
        return mineItem
    }()
    @objc func userInfo()  {
        if Global.share.user == nil{
            self.tabBarController?.present(loginViewController(), animated: true, completion: nil)
        }
    }
    // 搜素
    lazy var searchBtn: UIBarButtonItem = {
        let button = UIButton()
        button.setTitle("🔍", for: .normal)
        let searchItem = UIBarButtonItem.init(customView: button)
        return searchItem
    }()
    
    // 消息
    lazy var newItem: UIBarButtonItem = {
        let button = UIButton()
        button.setTitle("🔔", for: .normal)
        let newItem = UIBarButtonItem.init(customView: button)
        return newItem
    }()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        configNav()
        configUI()
        updateLayer()
  
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let gu = Global.share.user?.userName{
            let f:String = String(gu.prefix(1))
            minebtn.setTitle(f, for: .normal)
        }
    }
    
    lazy var griddata:[[String:Any]]={
        let datas = [
            [
                "name":"持仓",
                "icon":"sterlingsign.circle",
                "selector":"pushTransaction0"
            ],
            [
                "name":"卖出",
                "icon":"sterlingsign.circle",
                "selector":"pushTransaction1"
            ],
            [
                "name":"占位",
                "icon":"sterlingsign.circle",
                "selector":""
            ],
            [
                "name":0,
                "icon":"sterlingsign.circle",
                "selector":""
            ],
            [
                "name":"占位",
                "icon":"sterlingsign.circle",
                "selector":""
            ]
        ]
        return datas
    }()
    
    
}

extension HomeViewController{
    func configNav() {
        
        navigationItem.leftBarButtonItems = [mineItem]
        navigationItem.rightBarButtonItems = [newItem,searchBtn]
    }
    func configUI() {
        collecttionView.register(UINib(nibName: "HomeSummarizeCell", bundle: nil), forCellWithReuseIdentifier: "HomeSummarizeCell")
        collecttionView.register(UINib(nibName: "CollectionViewGridCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewGridCell")
        
    }
    func updateLayer()  {
       
       
    }

}

extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        case 1:
            return griddata.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section{
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"HomeSummarizeCell", for: indexPath)
            cell.backgroundColor = .random()
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"CollectionViewGridCell", for: indexPath) as! CollectionViewGridCell
            let data = griddata[indexPath.row]
            cell.imageView.image = .init(systemName: data["icon"].string())
            cell.titleLab.text = data["name"].string()
        
            return cell
            
        default:
            return UICollectionViewCell()
        }
     
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section{
        case 0:
            return .init(width: collectionView.size.width, height: 300)
        case 1:
            return .init(width: (collectionView.size.width-16)/5, height: (collectionView.size.width-16)/5)
        default:
            return .zero
        }
       
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section{
        case 0:
            break
        case 1:
            let data = griddata[indexPath.row]
            if let selector = data["selector"] as? String,
               selector.count>0
            {
                self.perform(Selector(selector), with: nil)
            }
        

        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section{
        case 0:
            return .init(top: 8, left: 8, bottom: 0, right: 8)
        case 1:
            return .init(top: 4, left: 8, bottom: 0, right: 8)
        default:
            return .zero
        }
    }
    
}

extension UIViewController{
    // 去持仓列表
    @objc func pushTransaction0(){
        let vc = TransactionListViewController()
        vc.state = 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // 去已卖出
    @objc func pushTransaction1(){
        let vc = TransactionListViewController()
        vc.state = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


