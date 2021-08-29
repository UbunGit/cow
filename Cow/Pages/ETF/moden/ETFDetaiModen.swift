//
//  File.swift
//  Cow
//
//  Created by admin on 2021/8/28.
//

import Foundation
var KDefualMAS = [5,10,20,30]

protocol ETFDetaiModenDelegate:BaseViewController {
  
}

class ETFDetaiModen {
    
    var speed:Int = 5{
        didSet{
            updateochl()
        }
    }
    var range = NSRange(location: 0, length: 100)
    var delegate:ETFDetaiModenDelegate?
    var select:Int = 0{
        didSet{
            if select >= ochl.count {
                select = ochl.count-1
            }
            self.delegate?.updateUI()
        }
    }
    private var _code:String?
    var code = ""{
        didSet{
            if _code == code {
                return
            }
            _code = code
            updateochl()
        }
    }
    var ochl:[[String:Any]] = []
    // 获取数据
    func updateochl()  {

        delegate?.view.loading()
        sm.select_etfdaily_kirogetf(
            speed: speed,
            fitter: " t1.code='\(code)' ",
                                    orderby: ["date"],
                                    limmit: range,
                                    isasc: false) { result in
            self.delegate?.view.loadingDismiss()
            switch result{
            case.failure(let err):
                self.delegate?.view.error(err.localizedDescription)
            case .success(let value):
                self.ochl = value.reversed()
                self.delegate?.updateUI()
            }
        }
    }
}
