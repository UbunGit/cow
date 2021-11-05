//
//  Color.swift
//  Cow
//
//  Created by admin on 2021/11/2.
//

import Foundation
import UIKit

extension UIColor{
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
}
