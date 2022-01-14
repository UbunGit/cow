//
//  Log.swift
//  Cow
//
//  Created by admin on 2022/1/8.
//

import Foundation
import Alamofire
extension DataRequest{
    static var islog = true
    func log(_ format: String, _ args: CVarArg...){
        if Self.islog{
            NSLog("【\(type(of: self))】 \(format)", args)
        }
    }
}
extension Session{
    static var islog = false
    func log(_ format: String, _ args: CVarArg...){
        if Self.islog{
            NSLog("【\(type(of: self))】 \(format)", args)
        }
    }
}

extension SqlliteManage{
    static var islog = true
    func log(_ format: String, _ args: CVarArg...){
        if Self.islog{
            NSLog("【\(type(of: self))】 \(format)", args)
        }
    }
}
extension OSS{
    static var islog = false
    func log(_ format: String, _ args: CVarArg...){
        if Self.islog{
            NSLog("【\(type(of: self))】 \(format)", args)
        }
    }
}
extension NSObject{
    static var islog = true
    func log(_ format: String, _ args: CVarArg...){
        if Self.islog{
            NSLog("【\(type(of: self))】 \(format)", args)
        }
    }
}
