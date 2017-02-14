//
//  IUJsonKitMacTests.swift
//  IUJsonKitMacTests
//
//  Created by ricky on 2017. 2. 14..
//  Copyright © 2017년 Appcid. All rights reserved.
//

import XCTest
@testable import IUJsonKitMac

class IUJsonKitMacTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        let string = "{\"name\":\"ricky\"}"
        let json = try! JSON(string: string)
        
        XCTAssertEqual("ricky", json["name"]!.string)
    }
    
    func testPerformanceExample() {
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
