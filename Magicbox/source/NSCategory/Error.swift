//
//  Error.swift
//  Magicbox
//
//  Created by admin on 2021/8/9.
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

public struct APIError: Error {
    
    public var code:Int
    public var title:String?
    public var msg:String
    
    public init(code:Int,msg:String) {
        self.code = code
        self.msg = msg
    }
    
}
