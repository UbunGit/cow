//
//  BaseViewController.swift
//  Cow
//
//  Created by admin on 2021/8/4.
//

import UIKit

protocol BasetModelDelegate:BaseViewController{
    
}

class BaseViewController: UIViewController,BasetModelDelegate {
    lazy var leftItem:UIBarButtonItem={
        let leftimg = UIImage(systemName: "chevron.left")
        leftimg?.byResize(to: .init(width: 12, height: 12))
        let baritem = UIBarButtonItem.init(image: leftimg, style: .plain, target: self, action: #selector(leftBackAction))
        baritem.tintColor = .cw_text4
   
        return baritem
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cw_pageBg
        if (navigationController?.children.count ?? 0 > 1) {
            navigationItem.leftBarButtonItem = leftItem
            navigationItem.hidesBackButton = true;
        }
    }
    @objc func leftBackAction(){
        navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        log("🍎 viewWillAppear")
    }
   
    
  
}
