//
//  SqlliteManage.swift
//  PlayGround
//
//  Created by admin on 2021/9/13.
//

import Foundation
import SQLite

let sm = SqlliteManage.share

/// Documnets目录
let SMDocumnetPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                        FileManager.SearchPathDomainMask.userDomainMask, true)
let SMDocumnetPath = SMDocumnetPaths[0]


class SqlliteManage {
    static let `share` = SqlliteManage()
    private init(){}
    var sqlpath:String = "\(SMDocumnetPath)/sqlite"
    
    public func sqlitePath() -> String{
        let sqlitePath = sqlpath
        let manager = FileManager.default
   
     
        let exist = manager.fileExists(atPath: sqlitePath)
        if !exist {
            try! manager.createDirectory(at: URL(fileURLWithPath: sqlitePath), withIntermediateDirectories: true,
                                         attributes: nil)
        }
       
        return  sqlitePath+"/sqlite.db"
    }
    
    public var db:Connection?{
        let path = sqlitePath()
        print("sql path \(path)")
        return try? Connection.init(path)
    }
}
