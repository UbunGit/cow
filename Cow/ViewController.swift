//
//  ViewController.swift
//  Cow
//
//  Created by admin on 2021/8/4.
//

import UIKit

class ViewController: UITabBarController,UITabBarControllerDelegate
{

    lazy var nav1: CSuperNavigationController = {
        let vc1 = HomeViewController()
        vc1.title = "首页"
        vc1.tabBarItem.image = UIImage(systemName: "house")
        let nav1 = CSuperNavigationController.init(rootViewController: vc1)
        return nav1
    }()
    
    lazy var nav2: CSuperNavigationController = {
        let vc1 = RecommendVC()
        vc1.title = "消息"
        vc1.tabBarItem.image = UIImage(systemName: "message")
        let nav1 = CSuperNavigationController.init(rootViewController: vc1)
        return nav1
    }()
    
    lazy var nav3: CSuperNavigationController = {
        let vc1 = FollowListViewController()
        vc1.title = "关注"
        vc1.tabBarItem.image = UIImage(systemName: "suit.heart")
        let nav1 = CSuperNavigationController.init(rootViewController: vc1)
        return nav1
    }()
    
    lazy var nav4: UINavigationController = {
        let vc1 = SettingVC()
        vc1.title = "设置"
        vc1.tabBarItem.image = UIImage(systemName: "light.min")
        let nav1 = CSuperNavigationController.init(rootViewController: vc1)
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
class CViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        if (navigationController?.children.count ?? 0 > 1) {
            navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(leftBackAction))
            navigationItem.hidesBackButton = true;
        }
    }
    @objc func leftBackAction(){
        navigationController?.popViewController(animated: true)
    }
}

class CSuperNavigationController: UINavigationController {
    override func viewDidLoad() {
        navigationBar.isTranslucent = false
        super.viewDidLoad()
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.children.count>0 {
            hidesBottomBarWhenPushed = true;
        }
        super.pushViewController(viewController, animated: true)
    }
}

