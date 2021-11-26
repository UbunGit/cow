//
//  SchemeStateObject.swift
//  Cow
//
//  Created by admin on 2021/11/25.
//

import UIKit

class SchemeStateObject: NSObject {
    
    var valueChange:(()->())? = nil
    var msg:((_ msg:String)->())? = nil
    
    var loading=false{
        didSet{
            datahash = "\(Data())"
        }
    }
    var error:String? = nil{
        didSet{
            datahash = "\(Data())"
        }
    }
    var datahash:String? = nil{
        didSet{
            valueChange?()
        }
    }
}
