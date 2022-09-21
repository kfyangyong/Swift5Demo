//
//  ReadApp.swift
//  Swift5Demo
//
//  Created by 阿永 on 2022/8/23.
//  Copyright © 2022 com.ayong.myapp. All rights reserved.
//

import Foundation

//MARK: - APP的启动

/* 冷、热启动
 APP的冷启动可以概括为3大阶段：dyld、runtime、main

 dyld（dynamic link editor）
 Apple的动态链接器，可以用来装载Mach-O文件（可执行文件、动态库等）。
 启动APP时，dyld所做的事情有：
    装载APP的可执行文件，同时会递归加载所有依赖的动态库.
    当dyld把可执行文件、动态库都装载完毕后，会通知Runtime进行下一步的处理.


 启动APP时，runtime所做的事情有:
 调用map_images进行可执行文件内容的解析和处理
 在load_images中调用call_load_methods，调用所有Class和Category的+load方法
 进行各种objc结构的初始化（注册Objc类 、初始化类对象等等）
 调用C++静态初始化器和attribute((constructor))修饰的函数
 
 接下来就是UIApplicationMain函数，
 AppDelegate的application:didFinishLaunchingWithOptions:方法

 */

//MARK: - 启动优化
/*
 减少动态库、合并一些动态库
 减少objc类、分类的数量、减少selector数量
 减少c++虚函数的数量
 swift 尽量使用struct
 
 在不影响用户体验的前提下，尽可能将一些操作延迟，不要全部都放在didFinishLaunchingWithOptions下
 按需加载
 */


