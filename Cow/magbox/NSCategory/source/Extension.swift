//
//  Extension.swift
//  PlayGround
//
//  Created by admin on 2021/9/13.
//

import Foundation

public extension Double {
    func double() -> Double{
        Double(self)
    }
    // 百分比
    func percentStr(_ formatter:String="%0.2f") -> String{
        
        return String(format: formatter, (self*100))+"%"
    }
    
    func price(_ formatter:String="%0.3f") -> String {
        return String(format: formatter, self)
    }
    func wanStr(_ defual:String = "%0.2f万") -> String {
        if self>=10000 {
            return .init(format: defual, self/10000.00)
        }else{
            var tdefual = defual
            tdefual =  defual.replacingOccurrences(of: "万", with: "")
            tdefual = defual.replacingOccurrences(of: "w", with: "")
            return .init(format: tdefual, self/1)
        }
    }
    
    
}

public extension String{
    func double(_ def:Double = 0) -> Double{
        Double(self) ?? def
    }
    func date(_ formatter:String = "yyyy-MM-dd HH:mm:ss") -> Date{
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = formatter
        guard let date = dateformatter.date(from: self) else {
            return Date()
        }
        
        return date
    }
}

public extension Float {
    func double() -> Double{
        Double(self)
    }
}

public extension Int {
    func double() -> Double{
        Double(self)
    }
    func string() -> String {
       
        return "\(self)"
    }
}

public extension Optional{
    
    func double(_ defual:Double = 0) -> Double {
        guard let value = self else {
            return defual
        }
        guard let value1 = Double("\(value)") else {
            return defual
        }
        return value1
    }
    func string() -> String {
        guard let str = self else {
            return ""
        }
        return "\(str)"
    }
    func int(_ defual:Int=0) -> Int {
        guard let value = self else {
            return defual
        }
        guard let value1 = Int("\(value)") else {
            return defual
        }
        return value1
    }
 
    func price(_ formatter:String="%0.3f") -> String {
        return String(format: formatter, self.double())
    }
    
    func wanStr(_ defual:String = "%0.2f万") -> String {
        if self.double()>=10000 {
            return .init(format: defual, self.double()/10000.00)
        }else{
            var tdefual = defual
            tdefual =  defual.replacingOccurrences(of: "万", with: "")
            tdefual = defual.replacingOccurrences(of: "w", with: "")
            return .init(format: tdefual, self.double()/1)
        }
    }
     
}

extension Date{
    
   public func toString(_ format:String="yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = format
        let date = formatter.string(from: self)
        return date
    }
}




