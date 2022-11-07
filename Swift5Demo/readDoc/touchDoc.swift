//
//  touchDoc.swift
//  Swift5Demo
//
//  Created by 阿永 on 2022/11/7.
//  Copyright © 2022 com.ayong.myapp. All rights reserved.
//

import Foundation

//MARK: - 讲讲iOS事件响应链的原理
/*
 响应者链通常是由视图（UIView）构成的；
 2、一个视图的下一个响应者是它视图控制器（UIViewController）（如果有的话），然后再转给它的父视图（Super View）；
 3、视图控制器（如果有的话）的下一个响应者为其管理的视图的父视图；
 4、单例的窗口（UIWindow）的内容视图将指向窗口本身作为它的下一个响应者
 需要指出的是，Cocoa Touch应用不像Cocoa应用，它只有一个UIWindow对象，因此整个响应者链要简单一点；
 5、单例的应用（UIApplication）是一个响应者链的终点，它的下一个响应者指向nil，以结束整个循环。
 */

//MARK: - 讲讲iOS事件响应与传递
/*
 事件的传递：由父视图到最佳子视图
 
 事件的响应：由子视图向父视图传递
 */
