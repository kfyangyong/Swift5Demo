//
//  AsyncAfter.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/1/28.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import Foundation

class AsyncAfter {
    ///延时执行闭包
    static func dispatch_later(time: TimeInterval, block: @escaping ()->()) {
        let t = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: t, execute: block)
    }
    
    typealias ExchangeableTask = (_ newDelayTime: TimeInterval?, _ anotherTask: @escaping (()->())) -> Void
    
    ///延迟执行一个任务，并支持在实际执行前替换新的任务，并设定新的延时时间
    static func delay(_ tiem: TimeInterval, task: @escaping ()->()) ->ExchangeableTask {
        var exchangingTask: (()->())?
        var newDelayTime: TimeInterval?
        let finalClosure = {
            if exchangingTask == nil {
                DispatchQueue.main.async(execute: task)
            }else {
                if newDelayTime == nil {
                    DispatchQueue.main.async {
                        print("任务更改 \(Date())")
                        exchangingTask!()
                    }
                }
                print("原任务取消，现在是\(Date())")
            }
        }
        dispatch_later(time: tiem) {
            finalClosure()
        }
        
        let exchangeTask: ExchangeableTask = {
            exchangingTask = $1
            newDelayTime = $0
            if $0 != nil {
                self.dispatch_later(time: $0!) {
                    exchangingTask!()
                    print("任务更改，现在是\(Date())")
                }
            }
        }
        return exchangeTask
    }
    
}


 
