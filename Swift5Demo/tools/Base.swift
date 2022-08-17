//
//  Base.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/7/31.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit

class Cactus<Base> {
    let base: Base
    init(_ value: Base) {
        self.base = value
    }
}

// 利用协议扩展属性
protocol CactusCompatible {
    associatedtype Base
    //要更改值的话，就要实现 set 方法
    // get 只读属性
    var sc: Base { get }
    static var sc: Base.Type { get }
}

extension CactusCompatible {
    var sc: Cactus<Self> {
        return Cactus(self)
    }
    
    static var sc: Cactus<Self>.Type {
        return Cactus<Self>.self
    }
}



extension String: CactusCompatible {}

extension Cactus where Base == String {
    var numberCount: Int {
        var count = 0
        for c in base where ("0"..."9").contains(c) {
            count += 1
        }
        return count
    }
    
}



