//
//  FollowModel.swift
//  Cow
//
//  Created by admin on 2021/8/11.
//

import Foundation
import SQLite
import HandyJSON
import Magicbox

public struct FollowModel:HandyJSON {
    
    var id:Int = 0
    public var code:String = ""
    public var name:String = ""
    public init() {
        
    }
}


