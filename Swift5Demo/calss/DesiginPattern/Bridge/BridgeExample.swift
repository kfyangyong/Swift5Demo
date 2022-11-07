//
//  BridgeExample.swift
//  Swift5DemoTests
//
//  Created by 阿永 on 2022/10/13.
//  Copyright © 2022 com.ayong.myapp. All rights reserved.
//

import XCTest

class Abstraction {
    
    fileprivate var implementation: Implementation
    
    init(_ implementation: Implementation) {
        self.implementation = implementation
    }
    
    func operation() -> String {
        let operation = implementation.operationImplementation()
        return "Abstraction: Base operation with:\n" + operation
    }
}
class ExtendedAbstraction: Abstraction {
    
    override func operation() -> String {
        let operation = implementation.operationImplementation()
        return "ExtendedAbstraction: Extended operation with:\n" + operation
    }
}

protocol Implementation {
    func operationImplementation() -> String
}
class ConcreteImplementationA: Implementation {
    
    func operationImplementation() -> String {
        return "ConcreteImplementationA: Here's the result on the platform A.\n"
    }
}

class ConcreteImplementationB: Implementation {
    
    func operationImplementation() -> String {
        return "ConcreteImplementationB: Here's the result on the platform B\n"
    }
}

class BridgeClient {
    // ...
    static func someClientCode(abstraction: Abstraction) {
        print(abstraction.operation())
    }
    // ...
}

final class BridgeExample: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testBridgeConceptual() {
        // The client code should be able to work with any pre-configured
        // abstraction-implementation combination.
        let implementation = ConcreteImplementationA()
        BridgeClient.someClientCode(abstraction: Abstraction(implementation))
        
        let concreteImplementation = ConcreteImplementationB()
        BridgeClient.someClientCode(abstraction: ExtendedAbstraction(concreteImplementation))
    }
    
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
