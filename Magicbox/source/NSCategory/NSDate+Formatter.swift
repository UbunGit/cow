//
//  NSDate+Formatter.swift
//  CYYCommonAPP
//
//  Created by admin on 2021/7/29.
//

import Foundation

extension Date{
    
    func mb_toString(_ format:String="yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = format
        let date = formatter.string(from: self)
        return date
    }
}
