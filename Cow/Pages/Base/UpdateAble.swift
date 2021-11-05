//
//  UpdateAble.swift
//  Cow
//
//  Created by admin on 2021/9/10.
//

import Foundation
import UIKit

protocol UpdateAble {
    
    func updateUI()
    func error(_ msg:Error)
}
extension UIView:UpdateAble{
    
    @objc func updateUI() {

    }
    @objc func error(_ msg:Error) {
        self.error(msg.localizedDescription)
    }
    
    
}
extension UIViewController:UpdateAble{
   @objc func updateUI() {

    }
    @objc func error(_ msg:Error) {
        view.error(msg.localizedDescription)
    }
    
    
}


