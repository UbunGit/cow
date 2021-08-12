//
//  SqlliteManageTest.swift
//  CowTests
//
//  Created by admin on 2021/8/12.
//

import XCTest
import Cow

class SqlliteManageTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIsTable() throws {
        let ma = SqlliteManage.share()
        let isexit = try ma.istable(tablename: "stockbasic")
        XCTAssert(isexit, "Pass");
  
    }
    func testMubalInster() throws {
        try sm.droptable(tablename: "test")
        try createtable(tablename: "test", column: ["name","code","area","industry","market","changeTime"])
        let datas =  (0...1000).map {
            return [
                "name":"name_\($0)",
                "code":"code_\($0)",
                "area":"area_\($0)",
                "industry":"industry_\($0)",
                "market":"market_\($0)",
                "changeTime":"changeTime_\($0)"
            ]
        }
        try sm.mutableinster(table: "test", column: ["name","code","area","industry","market","changeTime"], datas: datas)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
