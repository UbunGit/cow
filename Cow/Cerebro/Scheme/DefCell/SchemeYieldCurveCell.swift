//
//  SchemeYieldCurveCell.swift
//  Cow
//
//  Created by admin on 2021/11/5.
//

import UIKit
import Alamofire
class SchemeYieldCurve{
    var valueChange:(()->())? = nil
    var msg:((_ msg:String)->())? = nil
    var data:[[String:Any]]? = nil
    var pools:[[String:Any]] = []
    var error:Any? = nil
    var schemeId = 1
    
    func loadData(){
        AF.scheme_pool(schemeId).responseModel([[String:Any]].self) { result in
            switch result{
            case .success(let value):
                self.pools = value
                self.downdate()
            case .failure(let err):
                self.error = err
            }
            
          
        }
    }
    func downdate(){
        let group = DispatchGroup()
        if sm.isExistsTable("loc_ochl") == false{
            sm.createTable("loc_ochl")
        }
        
        
        
        pools.forEach { item in
            group.enter()
            let code = item["code"].string()
            let end:String? = nil
            
            var begin:String? = nil
            if let data = sm.select(" select max(date) from loc_ochl where code=\(code) ").last{
                begin = data["date"].string()
            }
            AF.dailydata(code, type: item["type"].int(), begin: begin, end: end)
                .responseModel([[String:Any]].self) { result in
                    switch result{
                    case .success(let value):
                        if sm.mutableinster(table: "loc_ochl", column: ["code","date","open","close","low","high","vol"], datas: value) == false{
                            
                        }
                        break
                    case .failure(let err):
                        break
                    }
                }
        }
        
    }
    
   
}

class SchemeYieldCurveCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
