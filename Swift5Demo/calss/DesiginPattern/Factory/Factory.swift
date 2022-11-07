//
//  Factory.swift
//  Swift5Demo
//
//  Created by 阿永 on 2022/8/23.
//  Copyright © 2022 com.ayong.myapp. All rights reserved.
//

//MARK: -  工厂方法生产一种产品，产品型号不同

import Foundation

// Creator 创造者;
protocol Creator {
    func factoryMethod() -> Product
    func someOperation() -> String
}

extension Creator {
    func someOperation() -> String {
        let product = factoryMethod()
        return "Creator: The same creator's code has just worked with " + product.operation()
    }
}

class ConcreteCreator1: Creator {
    public func factoryMethod() -> Product {
        return ConcreteProduct1()
    }
}

class ConcreteCreator2: Creator {

    public func factoryMethod() -> Product {
        return ConcreteProduct2()
    }
}

protocol Product {
    func operation() -> String
}

class ConcreteProduct1: Product {

    func operation() -> String {
        return "{Result of the ConcreteProduct1}"
    }
}
class ConcreteProduct2: Product {

    func operation() -> String {
        return "{Result of the ConcreteProduct2}"
    }
}

// Client委托人
class FactoryClient {
    /// 生产产品
    /// - Parameter creator: 传入生产者
    static func someClientCode(creator: Creator) {
        
        print("Client: I'm not aware of the creator's class, but it still works.\n"
            + creator.someOperation())
    }
    // ...
}

