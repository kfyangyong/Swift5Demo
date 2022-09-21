//
//  BuilderConceptual.swift
//  Swift5Demo
//
//  Created by 阿永 on 2022/8/25.
//  Copyright © 2022 com.ayong.myapp. All rights reserved.
//

import Foundation
/*
 生成器 （Builder） 接口声明在所有类型生成器中通用的产品构造步骤。
 具体生成器 （Con­crete Builders） 提供构造过程的不同实现。 具体生成器也可以构造不遵循通用接口的产品。
 产品 （Prod­ucts） 是最终生成的对象。 由不同生成器构造的产品无需属于同一类层次结构或接口。
 主管 （Direc­tor） 类定义调用构造步骤的顺序， 这样你就可以创建和复用特定的产品配置。
 客户端 （Client） 必须将某个生成器对象与主管类关联
 */
protocol BCBuilder {
    func ProducePartA()
    func ProducePartB()
    func ProducePartC()
}

class BCConcreteBuilder1: BCBuilder {
    
    private var product = BCProduct()
    func reset() {
        product = BCProduct()
    }
    func ProducePartA() {
        product.add(part: "PartA1")
    }
    
    func ProducePartB() {
        product.add(part: "PartB1")
    }
    
    func ProducePartC() {
        product.add(part: "PartC1")
    }
    
    func retrieveProduct() -> BCProduct {
        let result = self.product
        reset()
        return result
    }
}

class BCProduct {
    private var parts = [String]()
    func add(part: String) {
        self.parts.append(part)
    }
    
    func listParts() -> String {
        return "BCProduct parts:" + parts.joined(separator: ",") + "\n"
    }
}

class BCDirector {
    private var builder: BCBuilder?
    func update(builder: BCBuilder) {
        self.builder = builder
    }
    
    func buildMinimalViableProduct() {
        builder?.ProducePartA()
    }
    
    func buildFullFeaturedProduct() {
        builder?.ProducePartA()
        builder?.ProducePartB()
        builder?.ProducePartC()
    }
    
}
class BuilderConceptualClient {
    static func someClientCode(director: BCDirector) {
        let builder = BCConcreteBuilder1()
        director.update(builder: builder)
        print("标准版 product")
        director.buildMinimalViableProduct()
        print(builder.retrieveProduct().listParts())
        
        print("Full featured版 product")
        director.buildFullFeaturedProduct()
        print(builder.retrieveProduct().listParts())
        
        print("自定义版")
        builder.ProducePartC()
        builder.ProducePartA()
        print(builder.retrieveProduct().listParts())
    }
}
