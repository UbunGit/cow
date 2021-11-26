//
//  SchemezCgang.swift
//  Cow
//
//  Created by admin on 2021/11/17.
//

import Foundation
class SchemezContract{
    var schemeId = 1
    var selectDate:String = Date().toString("yyyyMMdd")
    var valueChange:(()->())? = nil
    var datas:[[String:Any]] = []
    var error:Any? = nil
    func loadData(){
        
        let sql = """
        SELECT * FROM back_trade
        WHERE scheme_id = \(schemeId) AND date='\(selectDate)'
        """
        self.datas = sm.select(sql)
        if let change = valueChange{
            change()
        }
       
    }
}
