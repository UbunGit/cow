//
//  Color.swift
//  Cow
//
//  Created by admin on 2021/11/2.
//

import Foundation
import UIKit

public extension UIColor{
    static var theme:UIColor = UIColor(named: "AccentColor") ?? .darkGray
    static var cw_bg1:UIColor = UIColor(named: "Background 1") ?? UIColor.white
    static var cw_bg5:UIColor = UIColor(named: "Background 5") ?? UIColor.white
    static var cw_pageBg:UIColor = UIColor(named: "Background 2") ?? UIColor.white
    
    static var cw_text1:UIColor = UIColor(named: "Text 1") ?? .lightText
    static var cw_text2:UIColor = UIColor(named: "Text 2") ?? .lightText
    static var cw_text3:UIColor = UIColor(named: "Text 3") ?? .lightText
    static var cw_text4:UIColor = UIColor(named: "Text 4") ?? .darkText
    static var cw_text5:UIColor = UIColor(named: "Text 5") ?? .darkText
    static var cw_text6:UIColor = UIColor(named: "Text 6") ?? .darkText
    
    static var mb_line:UIColor = UIColor(named: "Text 3") ?? .lightGray
    
    static var up:UIColor = UIColor(named: "up") ?? .red
    static var down:UIColor = UIColor(named: "down") ?? .green
    
    static func random()->UIColor{
        let r = CGFloat.random(in: 0...255)/255
        let g = CGFloat.random(in: 0...255)/255
        let b = CGFloat.random(in: 0...255)/255
        return UIColor(red: r, green: g, blue:b, alpha: 1)
    }
}
