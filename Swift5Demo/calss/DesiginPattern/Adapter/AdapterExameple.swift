//
//  AdapterExameple.swift
//  Swift5Demo
//
//  Created by 阿永 on 2022/8/26.
//  Copyright © 2022 com.ayong.myapp. All rights reserved.
//

import Foundation

//适配器是一种结构型设计模式， 它能使不兼容的对象能够相互合作。

//适配器可担任两个对象间的封装器， 它会接收对于一个对象的调用， 并将其转换为另一个对象可识别的格式和接口。
class AdapteeTarget {
    func request() -> String {
        return "Target: The default target's behavior."
    }
}

class Adaptee {
    public func specificRequest() -> String {
            return ".eetpadA eht fo roivaheb laicepS"
        }
}

class Adapter: AdapteeTarget {

    private var adaptee: Adaptee

    init(_ adaptee: Adaptee) {
        self.adaptee = adaptee
    }

    override func request() -> String {
        return "Adapter: (TRANSLATED) " + adaptee.specificRequest().reversed()
    }
}

class AdapterClient {
    // ...
    static func someClientCode(target: AdapteeTarget) {
        print(target.request())
    }
    // ...
}
