//
//  Loger.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/7/29.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import Foundation

func Loger(_ msg: String, file: NSString = #file, line:Int = #line, function:NSString = #function) {
    #if DEBUG
    print(file, "\n", line, function)
    print(msg)
    #endif
}
