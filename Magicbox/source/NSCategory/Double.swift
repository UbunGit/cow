//
//  Double.swift
//  Magicbox
//
//  Created by admin on 2021/8/20.
//

import Foundation
public extension Double {
    func double() -> Double{
        Double(self)
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
     
}



public extension Optional{
    func string() -> String {
        guard let str = self else {
            return ""
        }
        return "\(str)"
    }
 
    func price(_ formatter:String="%0.2f") -> String {
        return String(format: formatter, self.double())
    }
}
