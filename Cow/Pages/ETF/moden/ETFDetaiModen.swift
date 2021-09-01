//
//  File.swift
//  Cow
//
//  Created by admin on 2021/8/28.
//

import Foundation
import Alamofire
import Magicbox
var KDefualMAS = [5,10,20,30]

protocol ETFDetaiModenDelegate:BaseViewController {
  
}

class ETFDetaiModen {
    
    var scheme:Scheme?
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
    var code = ""
    var ochl:[[String:Any]] = []
    // 获取数据
    func updateochl()  {
        guard let schemetable = scheme?.tableName else {
            UIView.error("方案错误，没有表名")
            return
        }
        let sql = """
            SELECT t1.*,
            t2.sort, t2.count,t2.signal,
            t3.ma5,t3.ma10,t3.ma20,t3.ma30,t3.ma60
            from etfdaily as t1
            LEFT JOIN \(schemetable) as t2
            ON t1.code = t2.code AND t1.date = t2.date
            LEFT JOIN damreyetf as t3
            ON t1.code = t3.code AND t1.date = t3.date
            where  t1.code='\(code)'
            ORDER BY date  DESC
            LIMIT \(range.length) OFFSET \(range.location*range.length)
            """
        delegate?.view.loading()
        AF.af_select(sql) { result in
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
