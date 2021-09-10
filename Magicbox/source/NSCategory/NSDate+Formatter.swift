//
//  NSDate+Formatter.swift
//  CYYCommonAPP
//
//  Created by admin on 2021/7/29.
//

import Foundation

extension Date{
    
   public func toString(_ format:String="yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = format
        let date = formatter.string(from: self)
        return date
    }
}


extension String{
    
    public func toDate(_ formatter:String = "yyyy-MM-dd HH:mm:ss") -> Date{
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = formatter
        guard let date = dateformatter.date(from: self) else {
            return Date()
        }
        
        return date
    }
}
