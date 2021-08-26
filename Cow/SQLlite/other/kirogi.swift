//
//  kirogi.swift
//  Cow
//
//  Created by admin on 2021/8/25.
//

import Foundation
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
}


