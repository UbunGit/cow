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
    
    lazy var bandaView = HomeBandas.initWithNib()
    
    @IBOutlet weak var scorllview: UIScrollView!
    
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
    
}

extension HomeViewController{
    func configNav() {
        
        navigationItem.leftBarButtonItems = [mineItem]
        navigationItem.rightBarButtonItems = [newItem,searchBtn]
    }
    func configUI() {
        bandaView.backgroundColor = UIColor.red
        scorllview.backgroundColor = UIColor.yellow
        scorllview.addSubview(bandaView)
    }
    func updateLayer()  {
        bandaView.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.width.equalToSuperview()
            make.height.equalTo(300)
        }
       
    }

}


