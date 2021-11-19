//
//  UIbutton+Refresh.swift
//  Alamofire
//
//  Created by admin on 2021/9/10.
//

import Foundation
public extension UIView{
    
    // 旋转
    func beginrefresh() {
        let refresh = CABasicAnimation(keyPath: "transform.rotation.z")
        refresh.fromValue = 0
        refresh.toValue = Double.pi*2
        refresh.repeatCount = MAXFLOAT
        refresh.duration = 2
        refresh.isRemovedOnCompletion = false
        layer.add(refresh,forKey: "")
    }
    func transformAnimation(){
        self.layoutIfNeeded()
        
        let animationGroup = CAAnimationGroup.init()
        animationGroup.duration = 0.75
        animationGroup.beginTime = CACurrentMediaTime()
        animationGroup.repeatCount = .infinity
        animationGroup.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        let refresh = CABasicAnimation(keyPath: "transform.rotation.z")
        refresh.fromValue = 0
        refresh.toValue = Double.pi*2
        refresh.repeatCount = MAXFLOAT
        refresh.duration = 2
        refresh.isRemovedOnCompletion = false
        
        let alphaAnim = CABasicAnimation.init()
        alphaAnim.keyPath = "opacity"
        alphaAnim.fromValue = 1.0
        alphaAnim.toValue = 0
        
        animationGroup.animations = [refresh, alphaAnim]
        self.layer.add(animationGroup, forKey: nil)
    }
    
}
