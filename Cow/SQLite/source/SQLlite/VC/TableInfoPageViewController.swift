//
//  TableInfoPageViewController.swift
//  Cow
//
//  Created by admin on 2021/9/29.
//

import UIKit
import Magicbox

class TableInfoPageViewController: BaseViewController {

    var rootIN = 0 //表来源 0->服务器 1->本地
    var tableName:String!
    lazy var scrollerView: UIScrollView = {
        let scroller = UIScrollView()
        scroller.contentInsetAdjustmentBehavior = .never
        scroller.isPagingEnabled = true
        scroller.delegate = self
        return scroller
    }()
    
    lazy var headerView: StackHeaderView = {
        let headerView = StackHeaderView()
        headerView.backgroundColor = .cw_bg1
        return headerView
    }()
    
    lazy var viewControllers: [UIViewController] = {
        let infovc = (rootIN==0) ? SQLTableInfoVC() : SQLLocalTableInfoVC()
        infovc.tableName = tableName
        infovc.rootIN = rootIN
        
        let createVC = SQLTableCreateInfoVC()
        createVC.tableName = tableName
        createVC.view.backgroundColor = UIColor.random()
        createVC.rootIN = rootIN
        let vcs = [
            infovc,
            createVC,
            BaseViewController(),
            BaseViewController(),
            BaseViewController()
        ]
        return vcs
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = tableName
        view.addSubview(headerView)
        view.insertSubview(scrollerView, belowSubview: headerView)
        viewControllers.enumerated().forEach { (index,vc) in
            scrollerView.addSubview(vc.view)
            self.addChild(vc)
            vc.view.snp.makeConstraints { snp in
                snp.top.equalTo(0)
                snp.left.equalTo(KWidth*CGFloat(index))
                snp.width.equalTo(KWidth)
                snp.height.equalTo(scrollerView)
            }
        }
        updateUI()
       
    }
    override func updateUI() {
        scrollerView.contentSize = .init(width: CGFloat(viewControllers.count)*KWidth, height: scrollerView.bounds.size.height)

        headerView.datas = viewControllers.map{ "\($0.title.string("--"))"}
        headerView.reloadUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(44)
        }
        scrollerView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    

}
extension TableInfoPageViewController:UIScrollViewDelegate{
    
}
