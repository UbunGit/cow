//
//  HomeViewController.swift
//  Cow
//
//  Created by admin on 2021/8/4.
//

import UIKit
import Magicbox
import SnapKit
class HomeViewController: BaseViewController {

    // 我
    lazy var mineItem: UIBarButtonItem = {
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        button.setTitle("🐂", for: .normal)
        let mineItem = UIBarButtonItem.init(customView: button)
        button.mb_radius = 18
        button.mb_borderColor = UIColor(named: "Background 3")
        button.mb_borderWidth = 1
     
        return mineItem
    }()
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


