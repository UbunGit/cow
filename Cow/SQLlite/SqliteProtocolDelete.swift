//
//  SqliteProtocolDelete.swift
//  Cow
//
//  Created by admin on 2021/8/9.
//

import Foundation
import SQLite
extension SqliteProtocol{
    
    @discardableResult func delete(filter: Expression<Bool>? = nil) -> Bool{
        guard let ftable = table else {
            return false
        }
        return self.delete(table: ftable, filter: filter)
    }
    
    @discardableResult func delete(table:Table?,filter: Expression<Bool>? = nil) -> Bool{
        guard var filterTable = table else {
            return false
        }
        do {
            if let filterTemp = filter  {
                filterTable = filterTable.filter(filterTemp)
            }
            try db?.run(filterTable.delete())
            return true
        } catch let error {
            debugPrint(error.localizedDescription)
            return false
        }
    }
    
}
