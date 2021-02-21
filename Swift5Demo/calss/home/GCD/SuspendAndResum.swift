//
//  SuspendAndResum.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/1/28.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import Foundation

class SuspendAndResum {
    let creatQueueWithTask = GCDViewController()
    var concurrentQueue: DispatchQueue {
        return creatQueueWithTask.concurrentQueue
    }
    
    var suspendCount = 0 //队列挂起次数
    //MARK: - 队列方法
    
    ///挂起测试
    func suspendQueue() {
        creatQueueWithTask.printCurrentThred(with: "star thread")
        concurrentQueue.async {
            self.creatQueueWithTask.printCurrentThred(with: "concurrentQueue async task1")
        }
        concurrentQueue.async {
            self.creatQueueWithTask.printCurrentThred(with: "concurrentQueue async task2")
        }
        ///通过栅栏挂起任务
        let barrierTask = DispatchWorkItem(flags: .barrier) {
            self.safeSuspend(self.concurrentQueue)
        }
        concurrentQueue.async(execute: barrierTask)
        
        concurrentQueue.async {
            self.creatQueueWithTask.printCurrentThred(with: "concurrentQueue async task3")
        }
        concurrentQueue.async {
            self.creatQueueWithTask.printCurrentThred(with: "concurrentQueue async task4")
        }
        concurrentQueue.async {
            self.creatQueueWithTask.printCurrentThred(with: "concurrentQueue async task5")
        }
        
    }
    
    ///唤醒
    func resumeQueue() {
        self.safeResume(self.concurrentQueue)
    }
    ///安全的挂失
    func safeSuspend(_ queue: DispatchQueue) {
    suspendCount += 1
        queue.suspend()
        print("任务挂起")
    }
    ///唤醒
    func safeResume(_ queue: DispatchQueue) {
        if suspendCount == 1 {
            queue.resume()
            suspendCount = 0
            print("任务唤醒 safeResume")
        } else if suspendCount < 1 {
            print("任务唤醒次数过多")
        } else {
            queue.resume()
            suspendCount -= 1
            print("任务唤醒 safeResume 剩余次数\(suspendCount)")

        }
    }
    
    
}
