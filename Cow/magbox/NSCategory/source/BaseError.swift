//
//  BaseError.swift
//  PlayGround
//
//  Created by admin on 2021/9/13.
//

import Foundation

public struct BaseError: Error {
    
    public var code:Int
    public var title:String?
    public var msg:String
    
    public init(code:Int,msg:String) {
        self.code = code
        self.msg = msg
    }
}
