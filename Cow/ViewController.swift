//
//  ViewController.swift
//  Cow
//
//  Created by admin on 2021/8/4.
//

import UIKit

class ViewController: UITabBarController,UITabBarControllerDelegate
{

    lazy var nav1: BaseNavigationController = {
        let vc1 = HomeViewController()
        vc1.title = "首页"
        vc1.tabBarItem.image = UIImage(systemName: "house")
        let nav1 = BaseNavigationController.init(rootViewController: vc1)
        return nav1
    }()
    
    lazy var nav2: BaseNavigationController = {
        let vc1 = RecommendVC()
        vc1.title = "消息"
        vc1.tabBarItem.image = UIImage(systemName: "message")
        let nav1 = BaseNavigationController.init(rootViewController: vc1)
        return nav1
    }()
    
    lazy var nav3: BaseNavigationController = {
        let vc1 = FollowListViewController()
        vc1.title = "关注"
        vc1.tabBarItem.image = UIImage(systemName: "suit.heart")
        let nav1 = BaseNavigationController.init(rootViewController: vc1)
        return nav1
    }()
    
    lazy var nav4: UINavigationController = {
        let vc1 = SettingVC()
        vc1.title = "设置"
        vc1.tabBarItem.image = UIImage(systemName: "light.min")
        let nav1 = BaseNavigationController.init(rootViewController: vc1)
        return nav1
    }()
    
    override func loadView() {
        super .loadView()
        configUI()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
      
       
    }
  
    func configUI() {
        self.delegate = self;
        self.viewControllers = [nav1,nav2,nav3,nav4];

    }

}


class BaseNavigationController: UINavigationController {
    override func viewDidLoad() {
        navigationBar.isTranslucent = false
        super.viewDidLoad()
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.children.count>0 {
            viewController.hidesBottomBarWhenPushed = true;
        }
        super.pushViewController(viewController, animated: true)
    }
}

