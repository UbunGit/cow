//
//  ViewController.swift
//  Cow
//
//  Created by admin on 2021/8/4.
//

import UIKit

class ViewController: UITabBarController,UITabBarControllerDelegate
{

    lazy var nav1: UINavigationController = {
        let vc1 = HomeViewController()
        vc1.title = "首页"
        vc1.tabBarItem.image = UIImage(systemName: "house")
        let nav1 = UINavigationController.init(rootViewController: vc1)
        return nav1
    }()
    
    lazy var nav2: UINavigationController = {
        let vc1 = UIViewController()
        vc1.title = "消息"
        vc1.tabBarItem.image = UIImage(systemName: "message")
        let nav1 = UINavigationController.init(rootViewController: vc1)
        return nav1
    }()
    
    lazy var nav3: UINavigationController = {
        let vc1 = FollowListViewController()
        vc1.title = "关注"
        vc1.tabBarItem.image = UIImage(systemName: "suit.heart")
        let nav1 = UINavigationController.init(rootViewController: vc1)
        return nav1
    }()
    
    lazy var nav4: UINavigationController = {
        let vc1 = SettingVC()
        vc1.title = "设置"
        vc1.tabBarItem.image = UIImage(systemName: "light.min")
        let nav1 = UINavigationController.init(rootViewController: vc1)
        return nav1
    }()
    
    override func loadView() {
        super .loadView()
        configUI()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Task.task_createTable()
      
       
    }
  
    func configUI() {
        self.delegate = self;
        self.viewControllers = [nav1,nav2,nav3,nav4];

    }
  
    


}

