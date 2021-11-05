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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cw_pageBg
        if (navigationController?.children.count ?? 0 > 1) {
            navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(leftBackAction))
            navigationItem.hidesBackButton = true;
        }
    }
    @objc func leftBackAction(){
        navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("🍎\(self)")
    }
   
    
  
}
