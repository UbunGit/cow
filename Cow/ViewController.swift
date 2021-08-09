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
        let nav1 = UINavigationController.init(rootViewController: vc1)
        return nav1
    }()
    
    lazy var nav2: UINavigationController = {
        let vc1 = UIViewController()
        let nav1 = UINavigationController.init(rootViewController: vc1)
        return nav1
    }()
    
    lazy var nav3: UINavigationController = {
        let vc1 = UIViewController()
        let nav1 = UINavigationController.init(rootViewController: vc1)
        return nav1
    }()
    
    lazy var nav4: UINavigationController = {
        let vc1 = SettingVC()
        vc1.title = "设置"
        let nav1 = UINavigationController.init(rootViewController: vc1)
        return nav1
    }()
    
    override func loadView() {
        super .loadView()
        configUI()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    func configUI() {
        self.delegate = self;
//        view.backgroundColor = UIColor.init(named: "AccentColor")
        self.viewControllers = [nav1,nav2,nav3,nav4];
//        self.tabBar.backgroundImage
    }


}

