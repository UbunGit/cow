//
//  UIbutton+Refresh.swift
//  Alamofire
//
//  Created by admin on 2021/9/10.
//

import Foundation
public extension UIButton{
   
    func beginrefresh() {
        let refresh = CABasicAnimation(keyPath: "transform.rotation.z")
        refresh.fromValue = 0
        refresh.toValue = Double.pi*2
        refresh.repeatCount = MAXFLOAT
        refresh.duration = 2
        refresh.isRemovedOnCompletion = false
        layer.add(refresh,forKey: "")
    }
  
}
