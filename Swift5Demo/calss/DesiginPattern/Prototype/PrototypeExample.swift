//
//  PrototypeExample.swift
//  Swift5Demo
//
//  Created by 阿永 on 2022/8/25.
//  Copyright © 2022 com.ayong.myapp. All rights reserved.
//

import Foundation
//原型 （Pro­to­type） 接口将对克隆方法进行声明。
//在绝大多数情况下， 其中只会有一个名为 clone克隆的方法。

//具体原型 （Con­crete Pro­to­type） 类将实现克隆方法。
//除了将原始对象的数据复制到克隆体中之外，该方法有时还需处理克隆过程中的极端情况， 例如克隆关联对象和梳理递归依赖等等。
//
//客户端 （Client） 可以复制实现了原型接口的任何对象。

class BasePro­to­type: NSCopying, Equatable {
    private var intValue = 1
    private var stringValue = "Value"
    required init(intValue: Int = 1, stringValue: String = "Value") {
        self.intValue = intValue
        self.stringValue = stringValue
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let prototype = type(of: self).init()
        prototype.intValue = intValue
        prototype.stringValue = stringValue
        print("复制完成")
        return prototype
    }
    
    static func == (lhs: BasePro­to­type, rhs: BasePro­to­type) -> Bool {
        return lhs.intValue == rhs.intValue && lhs.stringValue == rhs.stringValue
    }
}

class SubClass: BasePro­to­type {
    private var boolValue = true
    func copy() -> Any {
        return copy(with: nil)
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        guard let prototype = super.copy(with: zone) as? SubClass else { return SubClass() }
        prototype.boolValue = boolValue
        print("Values defined in SubClass have been cloned!")
        return prototype
    }
    
}

class PrototypeClient {
    func someClientCode() {
       let original = SubClass(intValue: 2, stringValue: "你好酷！")
       guard let copy = original.copy() as? SubClass else {
//           XCTAssert(false)
           return
       }
//       XCTAssert(copy == original)
       print("原模型对象被成功复制")
   }
}
