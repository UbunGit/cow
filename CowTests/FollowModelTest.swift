//
//  FollerTest.swift
//  CowTests
//
//  Created by admin on 2021/8/12.
//

import XCTest
import Cow
import Magicbox
import SQLite

class FollowModelTest: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
       
    }
    func testCreateTable()throws {
     
        try sm.create_follow()
    }
    func testInsterExample() throws {
        
    
        
    }
    func testFitterExample() throws {
        
     
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

