//
//  SingletonExample.swift
//  Swift5Demo
//
//  Created by 阿永 on 2022/8/25.
//  Copyright © 2022 com.ayong.myapp. All rights reserved.
//

import Foundation

//单例 （Sin­gle­ton） 类声明了一个名为 get­Instance获取实例的静态方法来返回其所属类的一个相同实例。

//单例的构造函数必须对客户端 （Client） 代码隐藏。 调用 获取实例方法必须是获取单例对象的唯一方式。

class Sin­gle­tonClass {

    static var shared: Sin­gle­tonClass = {
        let instanece = Sin­gle­tonClass()
        //初始化的一些事情
        return instanece
    }()
    private init() {}
    
    func someBusinessLogic() -> String {
        return "** 单例 someBusinessLogic"
    }
 
}

extension Sin­gle­tonClass: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
