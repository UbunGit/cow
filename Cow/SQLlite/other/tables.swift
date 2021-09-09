//
//  rel_transaction.swift
//  Cow
//
//  Created by admin on 2021/9/6.
//

import Foundation
let creatdTabledic =
    [
        "rel_transaction":"""
                            CREATE TABLE "rel_transaction" (
                            "id"    INTEGER NOT NULL UNIQUE,
                            "userid"    INT NOT NULL,
                            "code"    TEXT NOT NULL,
                            "type"    INTEGER,
                            "bcount"    INTEGER,
                            "bdate"    TEXT NOT NULL,
                            "bprice"    NUMERIC NOT NULL,
                            "bfree"    NUMERIC,
                            "sdate"    TEXT,
                            "sprice"    NUMERIC,
                            "sfree"    NUMERIC,
                            "target" NUMERIC,
                            "plan"    TEXT,
                            "remarks"  TEXT,
                            PRIMARY KEY("id" AUTOINCREMENT)
                        );
                        """
]

extension SqlliteManage{
    func sql_createTable(_ tablename:String) -> String? {

        return creatdTabledic[tablename]
    }
}
