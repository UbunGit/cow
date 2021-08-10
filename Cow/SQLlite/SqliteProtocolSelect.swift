//
//  SqliteProtocolSelect.swift
//  Cow
//
//  Created by admin on 2021/8/9.
//

import Foundation
import SQLite
import HandyJSON

extension SqliteProtocol{
    func select(
        select: [Expressible] = [],
        filter: Expression<Bool>? = nil,
        order: [Expressible] = [],
        limit: Int? = nil,
        offset: Int? = nil) -> [Self]?
    {
        guard let stable = table else {
            return nil
        }
        return self.select(table: stable, select: select, filter: filter, order: order, limit: limit, offset: offset)
    }
    
    func select(
        table:Table?,
        select: [Expressible] = [],
        filter: Expression<Bool>? = nil,
        order: [Expressible] = [],
        limit: Int? = nil,
        offset: Int? = nil) -> [Self]?
    {
        guard var queryTable = table else {
            return nil
        }
        do {
         
            if select.count != 0{
                queryTable = queryTable.select(select).order(order)
            }else{
                queryTable = queryTable.order(order)
            }
            
            if let filterTemp = filter {
                queryTable = queryTable.filter(filterTemp)
            }
            if let lim = limit{
                if let off = offset {
                    queryTable = queryTable.limit(lim, offset: off)
                }else{
                    queryTable = queryTable.limit(lim)
                }
            }
            guard let dresult = try db?.prepare(queryTable) else { return nil }
            let result = dresult.map { row -> Self in
                Self.init(row: row)
            }
            return result
        } catch let error {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    
}
