//
//  SqliteProtocolInster.swift
//  Cow
//
//  Created by admin on 2021/8/9.
//

import Foundation
import SQLite

extension SqliteProtocol{
    
    @discardableResult func insert (
        setters:[Setter]
    ) -> Bool{
        guard let itable = table else {
            return false
        }
        return self.insert(table: itable, setters: setters)
       
    }
    
    @discardableResult func insert (
        table:Table?,
        setters:[Setter]
    ) -> Bool{
        guard let tab = table else {
            return false
        }
        do {
            try db?.run(tab.insert(setters))
            return true
        } catch let error {
            debugPrint(error.localizedDescription)
            return false
        }
    }
    
}
