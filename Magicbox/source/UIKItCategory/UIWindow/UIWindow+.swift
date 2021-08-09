//
//  UIWindow+.swift
//  CYYComponent
//
//  Created by admin on 2021/8/2.
//

import Foundation

/// Window
public let KWindow = UIApplication.shared.delegate?.window

/// 安全上部距离
public let KSafeTop:CGFloat = UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0

/// 安全底部距离
public let KSafeBottom:CGFloat = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0

/// 屏幕宽度
public let KWidth = UIScreen.main.bounds.width

/// 屏幕高度
public let KHeight = UIScreen.main.bounds.height

public func K_AutoWidth(_ width:CGFloat) -> CGFloat{
    return (375.0/KWidth) * width
}

