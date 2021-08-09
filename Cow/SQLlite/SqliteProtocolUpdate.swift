//
//  SqliteProtocolUpdate.swift
//  Cow
//
//  Created by admin on 2021/8/9.
//

import Foundation
import SQLite

extension SqliteProtocol{
    
    @discardableResult func update(
        setters:[Setter],
        filter: Expression<Bool>? = nil
    ) -> Bool {
        guard let utable = table else {
            return false
        }
        return self.update(table: utable, setters: setters, filter: filter)
        
    }
    @discardableResult func update(
        table:Table?,
        setters:[Setter],
        filter: Expression<Bool>? = nil
    ) -> Bool {
        guard var filterTable = table else {
            return false
        }
        do {
            if let filterTemp = filter  {
                filterTable = filterTable.filter(filterTemp)
            }
            try db?.run(filterTable.update(setters))
            return true
        } catch let error {
            debugPrint(error.localizedDescription)
            return false
        }
    }
    
}
