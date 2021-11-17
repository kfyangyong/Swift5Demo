//
//  DynamicType.swift
//  Swift5Demo
//
//  Created by 杨永 on 2021/10/14.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import Foundation


struct DynamicType<T> {
    typealias ModelEventListener = (T) -> Void
    typealias Listeners = [ModelEventListener]
    
    private var listeners: Listeners = []
    
    var value: T?
    
}
