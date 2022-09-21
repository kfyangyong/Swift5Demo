//
//  ReadGCD.swift
//  Swift5Demo
//
//  Created by 阿永 on 2022/8/23.
//  Copyright © 2022 com.ayong.myapp. All rights reserved.
//

import Foundation
// gcd 学习说明文档

/*
 GCD 可用于多核的并行运算
     会自动利用更多的CPU内核
     会自动管理线程的生命周期
 
 NSOperation、NSOperationQueue 是基于 GCD 更高一层的封装，完全面向对象。
 比 GCD 更简单易用、代码可读性也更高。
    可添加完成的代码块，在操作完成后执行
    添加操作之间的依赖关系，设定操作执行的优先级，方便的控制优先顺序，设置最大并发数
 可以很方便的取消一个操作的执行
 使用kvo观察对操作执行状态的更改： isExecuteing、isFinished、isCancelled。

 同步和异步主要影响：能不能开启新的线程
 同步：在当前线程中执行任务，不具备开启新线程的能力
 异步：在新的线程中执行任务，具备开启新线程的能力
 
 并发和串行主要影响：任务的执行方式
 并发：多个任务并发（同时）执行
 串行：一个任务执行完毕后，再执行下一个任务
 
 */
