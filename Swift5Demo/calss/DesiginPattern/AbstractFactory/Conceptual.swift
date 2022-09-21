//
//  Conceptual.swift
//  Swift5Demo
//
//  Created by 阿永 on 2022/8/23.
//  Copyright © 2022 com.ayong.myapp. All rights reserved.
//

import Foundation

protocol AbstractFactory {

    func createProductA() -> AbstractProductA
    func createProductB() -> AbstractProductB
}

class ConcreteFactory1: AbstractFactory {
    func createProductA() -> AbstractProductA {
        return ConcreteProductA1()
    }
    func createProductB() -> AbstractProductB {
        return ConcreteProductB1()
    }

}
class ConcreteFactory2: AbstractFactory {
    func createProductA() -> AbstractProductA {
        return ConcreteProductA2()
    }
    func createProductB() -> AbstractProductB {
        return ConcreteProductB2()
    }
}


protocol AbstractProductA {
    func usefulFunctionA() -> String
}

class ConcreteProductA1: AbstractProductA {
    func usefulFunctionA() -> String {
        return "The result of the product A1."
    }
}

class ConcreteProductA2: AbstractProductA {
    func usefulFunctionA() -> String {
        return "The result of the product A2."
    }
}


protocol AbstractProductB {
    func usefulFunctionB() -> String
    func anotherUsefulFunctionB(collaborator: AbstractProductA) -> String
}

class ConcreteProductB1: AbstractProductB {

    func usefulFunctionB() -> String {
        return "The result of the product B1."
    }

    func anotherUsefulFunctionB(collaborator: AbstractProductA) -> String {
        let result = collaborator.usefulFunctionA()
        return "The result of the B1 collaborating with the (\(result))"
    }
}

class ConcreteProductB2: AbstractProductB {

    func usefulFunctionB() -> String {
        return "The result of the product B2."
    }
    
    func anotherUsefulFunctionB(collaborator: AbstractProductA) -> String {
        let result = collaborator.usefulFunctionA()
        return "The result of the B2 collaborating with the (\(result))"
    }
}


class AbstractFactoryClient {
    static func someClientCode(factory: AbstractFactory) {
        let productA = factory.createProductA()
        let productB = factory.createProductB()

        print(productB.usefulFunctionB())
        print(productB.anotherUsefulFunctionB(collaborator: productA))
    }
}
