//
//  CowTests.swift
//  CowTests
//
//  Created by admin on 2021/8/12.
//

import XCTest
import Cow

class CowTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

public func createtable(tablename:String,column:[String],id:Bool = false) throws{
    
    let sql = """
        CREATE TABLE IF NOT EXISTS "\(tablename)" (
        \(column.map{
            "\($0) TEXT NOT NULL"
        }.joined(separator: ","))
        );
        """
    try sm.db?.execute(sql)

}
