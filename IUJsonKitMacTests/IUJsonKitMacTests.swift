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
    
    let bundle = Bundle.init(for: IUJsonKitMacTests.self)
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testJsonSimple() {
        let string = "{\"name\":\"ricky\"}"
        let json = try! JSON(string: string)
        
        XCTAssertEqual("ricky", json["name"]!.string!)
    }
    
    func testJsonFile() {
        let path = bundle.path(forResource: "jsonexample", ofType: "strings")
        let string = try! String(contentsOfFile: path!)
        let json = try! JSON(string: string)
        
        print(json)
        
        XCTAssertEqual("example glossary", json["glossary"]!["title"]!.string!)
    }
    
}
