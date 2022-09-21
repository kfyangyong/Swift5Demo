//
//  PrototypeClientTests.swift
//  Swift5DemoTests
//
//  Created by 阿永 on 2022/8/25.
//  Copyright © 2022 com.ayong.myapp. All rights reserved.
//

import XCTest
@testable import Swift5Demo

class PrototypeClientTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let original = SubClass(intValue: 2, stringValue: "你好酷！")
        guard let copy = original.copy() as? SubClass else {
            XCTAssert(false)
            return
        }
        XCTAssert(copy == original)
        print("原模型对象被成功复制")
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
