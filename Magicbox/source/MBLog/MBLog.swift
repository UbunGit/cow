//
//  File.swift
//  Magicbox
//
//  Created by admin on 2022/1/8.
//

import Foundation

public extension NSObject{
    func MBLog(_ format: String, _ args: CVarArg...){
        NSLog(format, args)
    }
}

