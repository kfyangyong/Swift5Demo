//
//  BuilderExampleTests.swift
//  Swift5DemoTests
//
//  Created by 阿永 on 2022/8/25.
//  Copyright © 2022 com.ayong.myapp. All rights reserved.
//

import XCTest
@testable import Swift5Demo

class BuilderExampleTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let director = BCDirector()
        BuilderConceptualClient.someClientCode(director: director)
        
    }
    func testBuilderRealWorld() {
        print("Client: Start fetching data from Realm")
        clientCode(builder: RealmQueryBuilder<User>())


        print("Client: Start fetching data from CoreData")
        clientCode(builder: CoreDataQueryBuilder<User>())
    }

    fileprivate func clientCode(builder: BaseQueryBuilder<User>) {

        let results = builder.filter({ $0.age < 20 })
            .limit(10)
            .fetch()

        print("Client: I have fetched: " + String(results.count) + " records.")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
