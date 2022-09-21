//
//  SingletonExampleTests.swift
//  Swift5DemoTests
//
//  Created by 阿永 on 2022/8/25.
//  Copyright © 2022 com.ayong.myapp. All rights reserved.
//

import XCTest
@testable import Swift5Demo

class SingletonExampleTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let instance1 = Sin­gle­tonClass.shared
        let instance2 = Sin­gle­tonClass.shared
        XCTAssert(instance1 === instance2)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
