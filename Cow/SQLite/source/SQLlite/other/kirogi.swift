//
//  kirogi.swift
//  Cow
//
//  Created by admin on 2021/8/25.
//

import Foundation
import Alamofire
extension SqlliteManage{
    
    
    
    func kirogidates(limmit:NSRange? = nil, type:String="stock") throws -> [[String:Any]] {
        
        
        let sql = """
                select date from kirogi\(type)
                GROUP BY date
                ORDER BY date DESC
                LIMIT 10 OFFSET 0
                """
        guard let datas = try db?.prepare(sql).to_dict() else {
            return []
        }
        return datas
    }
    
    func kirogidatesSql(limmit:NSRange = NSRange(location: 0, length: 10), type:String="stock") -> String {
        
        
        let sql = """
                select date from kirogi\(type)
                GROUP BY date
                ORDER BY date DESC
                LIMIT \(limmit.length) OFFSET \(limmit.location*limmit.length)
                """
       
        return sql
    }
    
    func af_kirogidates(limmit:NSRange = NSRange(location: 0, length: 10), type:String="stock", callback:@escaping (Result< [[String:Any]], Error>)  ->  ()) {
        let url = "\(baseurl)/select"
        let param = ["sql":self.kirogidatesSql(limmit: limmit, type: type)
        ]
        AF.request(url, method: .post, parameters: param, encoder: JSONParameterEncoder.default)
            .responseModel([[String:Any]].self, callback: callback) 
    }
}


