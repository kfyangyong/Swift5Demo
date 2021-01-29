//
//  GCDViewController.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/1/28.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit

//测试任务是否在指定队列中，通过给队列设置一个标识， 使用dis 获取标识，能获取到说明在该队列中
enum DispatchTaskType: String {
    case serial
    case concurrent
    case mian
    case gloabal
}

class GCDViewController: BaseViewController {
    
    let serualQueue = DispatchQueue(label: "com.sinkingsoul.dispatchqueue.serualQueue")
    let concurrentQueue = DispatchQueue.init(label: "com.sinkingsoul.dispatchqueue.concurrentQueue",
                                             attributes: .concurrent)
    let mainQueue = DispatchQueue.main
    let globalQueue = DispatchQueue.global()
    
    let serualQueueKey = DispatchSpecificKey<String>()
    let concurrentQueueKey = DispatchSpecificKey<String>()
    let mainQueueKey = DispatchSpecificKey<String>()
    let globalQueueKey = DispatchSpecificKey<String>()
    
    var signal: DispatchSourceSignal!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initQuete()
        
        //        testSyncTaskInSerialQueue()
        //        testAsyncTaskInSerialQueue()
        //        barrierTask()
        //        concurrentPerformTask()
        //        delayTime()
        //        testGroup()
        //        groupNoti()
        dispatchForSignal()
    }
    
    func dispatchForSignal(){
        printTime(withComment: "4")
        signal = DispatchSource.makeSignalSource(signal: Int32(SIGSTOP))
        
        signal.setEventHandler {
            self.printTime(withComment: "SIGSTOP")
        }
        signal.activate()
        printTime(withComment: "5")
    }
    func printTime(withComment comment: String){
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        print(comment + ": " + formatter.string(from: date))
    }
    
    //MARK: - 队列的详细属性
    func about() {
        //        let queue = DispatchQueue(label: "", qos: DispatchQoS.background, attributes: DispatchQueue.Attributes.initiallyInactive, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.workItem, target: .main)
        
        //lable 名称
        
        //qos 队列优先级
        /*  低到高
         * case background
         * case utility
         * case `default`
         * case userInitiated
         * case userInteractive
         */
        
        //attributes
        /* DispatchQueue.Attributes.initiallyInactive 需手动触发 queue.activate()
         * concurrent 标识并行队列
         */
        
        //autoreleaseFrequency
        /*
         case inherit 继承目标队列
         case workItem 跟随每个任务自动创建释放
         case never 手动管理
         */
        
        //target 主队列 或全局并发队列
    }
    
    ///延时执行
    func delayTime() {
        print("延时 start time: \(Date())")
        let task = AsyncAfter.delay(2) {
            print("延时后执行 \(Date())")
        }
        task(3) {
            print("更改延时后执行 \(Date())")
        }
    }
    
    //MARK: - 队列
    private func quete() {
        
        //串行队列
        let queueC = DispatchQueue(label: "com.chaunxing.queueName")
        //并行队列
        let queueB = DispatchQueue(label: "com.bingxing.queueName", attributes: .concurrent)
        //主对列
        let mainQueue = DispatchQueue.main
        // 默认的
        let globalQueue = DispatchQueue.global()
        //后台运行级别
        let globalBackgroundQueue = DispatchQueue.global(qos: .background)
        
        //MARK: - 线程
        //串行队列有任务，同步会死锁
        
        queueB.sync {
            //同步线程
        }
        
        queueB.async {
            //异步线程
        }
        
    }
    
    private func initQuete() {
        serualQueue.setSpecific(key: serualQueueKey, value: DispatchTaskType.serial.rawValue)
        concurrentQueue.setSpecific(key: concurrentQueueKey, value: DispatchTaskType.concurrent.rawValue)
        mainQueue.setSpecific(key: mainQueueKey, value: DispatchTaskType.mian.rawValue)
        globalQueue.setSpecific(key: globalQueueKey, value: DispatchTaskType.gloabal.rawValue)
    }
    
    //测试是否在指定队列
    func testIsTaskInQueue(_ queueType: DispatchTaskType, key: DispatchSpecificKey<String>) {
        let value = DispatchQueue.getSpecific(key: key)
        let opnvalue: String? = queueType.rawValue
        print("is task in \(queueType.rawValue) queue: \(value == opnvalue)")
    }
    
    //打印当前线程
    func printCurrentThred(with des: String, _ terminator: String = "") {
        print("\(des) at thread: \(Thread.current), thid is \(Thread.isMainThread ? "" : "not") main thread \(terminator)")
    }
    
    ///串行队列新增同步任务
    func testSyncTaskInSerialQueue() {
        printCurrentThred(with: "start test")
        serualQueue.sync {
            print("serualQueue sync task ->>")
            self.printCurrentThred(with: "serualQueue sync task")
            self.testIsTaskInQueue(.serial, key: self.serualQueueKey)
            print("->> serualQueue sync task \n")
        }
        self.printCurrentThred(with: "end test")
    }
    
    ///串行队列任务嵌套本队列同步任务 (会崩溃)
    func testSyncTaskInSameSerialQueue() {
        printCurrentThred(with: "start test")
        serualQueue.async {
            print("serualQueue async task ->>")
            self.printCurrentThred(with: "serualQueue sync task")
            self.testIsTaskInQueue(.serial, key: self.serualQueueKey)
            self.serualQueue.sync {
                print("serualQueue sync task ->>")
                self.printCurrentThred(with: "serualQueue sync task")
                self.testIsTaskInQueue(.serial, key: self.serualQueueKey)
                print("->> serualQueue sync task \n")
            }
            print("->> serualQueue async task \n")
        }
        self.printCurrentThred(with: "end test")
    }
    
    ///并行队列任务嵌套本队列同步任务
    func testSyncTaskInSameConcurrentQueue() {
        printCurrentThred(with: "start test")
        serualQueue.async {
            print("ConcurrentQueue async task ->>")
            self.printCurrentThred(with: "ConcurrentQueue sync task")
            self.testIsTaskInQueue(.serial, key: self.serualQueueKey)
            self.serualQueue.sync {
                print("ConcurrentQueue sync task ->>")
                self.printCurrentThred(with: "ConcurrentQueue sync task")
                self.testIsTaskInQueue(.serial, key: self.serualQueueKey)
                print("->> ConcurrentQueue sync task \n")
            }
            print("->> ConcurrentQueue async task \n")
        }
        self.printCurrentThred(with: "end test")
    }
    
    ///串行队列任务嵌套其他队列同步任务
    func testSyncTaskInOtherSerialQueue() {
        let serualQueue2 = DispatchQueue(label: "com.sinkingsoul.dispatchqueue.serualQueue2")
        let serualQueueKey2 = DispatchSpecificKey<String>()
        serualQueue2.setSpecific(key: serualQueueKey2, value: "serualQueue2")
        
        printCurrentThred(with: "start test")
        serualQueue.async {
            print("serualQueue async task ->>")
            self.printCurrentThred(with: "serualQueue sync task")
            self.testIsTaskInQueue(.serial, key: self.serualQueueKey)
            serualQueue2.sync {
                print("serualQueue2 sync task ->>")
                self.printCurrentThred(with: "serualQueue2 sync task")
                self.testIsTaskInQueue(.serial, key: self.serualQueueKey)
                let value = DispatchQueue.getSpecific(key: serualQueueKey2)
                let opn = "serial2"
                print("is task in serualQueue2 queue: \(value == opn)")
                
                print("->> serualQueue2 sync task \n")
            }
            print("->> serualQueue async task \n")
        }
        self.printCurrentThred(with: "end test")
    }
    
    
    //MARK: - 异步任务
    ///并行队列新增异步任务
    func testAsyncTaskInConcurrentQueue() {
        printCurrentThred(with: "start test")
        concurrentQueue.async {
            print("concurrentQueue async task ->>")
            self.printCurrentThred(with: "concurrentQueue async task")
            self.testIsTaskInQueue(.serial, key: self.serualQueueKey)
            print("->> concurrentQueue async task \n")
        }
        self.printCurrentThred(with: "end test")
    }
    
    ///串行队列新增异步任务
    func testAsyncTaskInSerialQueue() {
        printCurrentThred(with: "start test")
        serualQueue.async {
            print("serualQueue async task ->>")
            self.printCurrentThred(with: "serualQueue async task")
            self.testIsTaskInQueue(.serial, key: self.serualQueueKey)
            print("->> serualQueue async task \n")
        }
        self.printCurrentThred(with: "end test")
    }
    
    ///串行队列任务嵌套本队列异步任务
    func testAsyncTaskInSameSerialQueue() {
        printCurrentThred(with: "start test")
        serualQueue.async {
            print("serualQueue async task ->>")
            self.printCurrentThred(with: "serualQueue sync task")
            self.testIsTaskInQueue(.serial, key: self.serualQueueKey)
            self.serualQueue.async {
                print("serualQueue async task ->>")
                self.printCurrentThred(with: "serualQueue async task")
                self.testIsTaskInQueue(.serial, key: self.serualQueueKey)
                print("->> serualQueue async task \n")
            }
            print("->> serualQueue async task \n")
        }
        self.printCurrentThred(with: "end test")
    }
    
    //MARK: - 栅栏任务 等队列中已有任务完成后在执行
    func initWorkItem() {
        
        let queue = DispatchQueue(label: "com.workItem.queue", attributes: .concurrent)
        let task = DispatchWorkItem(flags: DispatchWorkItemFlags.barrier) {
            
        }
        
        queue.async(execute: task)
        queue.sync(execute: task)
        
    }
    
    ///栅栏任务。123在栅栏任务前同时执行  456 在栅栏任务后同时执行
    func barrierTask() {
        let queue = concurrentQueue
        let barrierTask = DispatchWorkItem(flags: .barrier) {
            print("\nbarrier task -->")
            self.printCurrentThred(with: "barrier task")
            print("---> barrier task\n")
        }
        printCurrentThred(with: "start task")
        queue.async {
            print("\nasync task1 -->")
            self.printCurrentThred(with: "async task1")
            print("--> async task1")
        }
        queue.async {
            print("\nasync task2 -->")
            self.printCurrentThred(with: "async task2")
            print("--> async task2")
        }
        queue.async {
            print("\nasync task3 -->")
            self.printCurrentThred(with: "async task3")
            print("--> async task3")
        }
        queue.async(execute: barrierTask)
        queue.async {
            print("\nasync task4 -->")
            self.printCurrentThred(with: "async task4")
            print("--> async task4")
        }
        
        queue.async {
            print("\nasync task5 -->")
            self.printCurrentThred(with: "async task5")
            print("--> async task5")
        }
        
        queue.async {
            print("\nasync task6 -->")
            self.printCurrentThred(with: "async task6")
            print("--> async task6")
        }
        printCurrentThred(with: "end test")
        
    }
    
    //MARK: - 迭代任务 一个任务分解为多个相似但独立的任务
    
    func initPerform() {
        DispatchQueue.concurrentPerform(iterations: 10) { (index) in
            //TODO: -
            //index 10 迭代次数
            
        }
        
        //迭代任务可以单独执行，也可以放在指定队列中
        let queue = DispatchQueue.global()
        queue.async {
            DispatchQueue.concurrentPerform(iterations: 100) { (index) in
                // 100 次
            }
            //跳转到主线程任务
            DispatchQueue.main.async {
                
            }
        }
        
    }
    
    func concurrentPerformTask() {
        printCurrentThred(with: "start task")
        
        let array  = Array(1...100)
        var result: [Int] = []
        let queue = DispatchQueue.global()
        queue.async {
            DispatchQueue.concurrentPerform(iterations: 100) { (index) in
                // 100 次
                if self.isDivided(13, with: array[index]) {
                    self.printCurrentThred(with: "find a match: \(array[index])")
                    self.mainQueue.async {
                        result.append(array[index])
                    }
                }
            }
            self.printCurrentThred(with: "concurrentPerform task end")
            
            //跳转到主线程任务
            DispatchQueue.main.async {
                print("--> back main thread")
                print("result find match: \(result)")
            }
        }
        printCurrentThred(with: "task end")
    }
    
    func isDivided(_ divisor: Int, with number: Int) -> Bool {
        return number % divisor == 0
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension GCDViewController {
    //MARK: - 任务组
    
    //
    func testGroup() {
        let group = DispatchGroup()
        let queue = DispatchQueue.global()
        queue.async(group: group) {
            sleep(2)
            print("刷牙")
        }
        group.enter()
        queue.async {
            print("洗脸")
            group.leave()
        }
        print("起床")
    }
    
    // 等待两组任务做完后在执行
    func groupNoti() {
        let group = DispatchGroup()
        
        print("start \(Date())")
        let queue1 = DispatchQueue(label: "book")
        let queue2 = DispatchQueue(label: "video")
        
        queue1.async(group: group) {
            sleep(2)
            print("开始读书\(Date())")
        }
        queue2.async(group: group) {
            sleep(5)
            print("开始看视频 \(Date())")
        }
        group.notify(queue: DispatchQueue.main) {
            print("all task end\(Date())")
        }
        print("end")
    }
    
    
    func groupWait() {
        let group = DispatchGroup()
        
        print("start \(Date())")
        let queue1 = DispatchQueue(label: "book")
        let queue2 = DispatchQueue(label: "video")
        let queue3 = DispatchQueue(label: "backhome")
        
        queue1.async(group: group) {
            sleep(2)
            print("开始读书\(Date())")
        }
        queue2.async(group: group) {
            sleep(5)
            print("开始看视频 \(Date())")
        }
        print("wite")
        group.wait()
        
        //定义等待时间
        //        let waiteTime = DispatchTime.now() + 2.0
        //        group.wait(timeout: waiteTime)
        
        queue3.async(group: group) {
            sleep(5)
            print("回家 \(Date())")
        }
        print("end")
    }
}

//MARK: - dispatchsource 监听系统底层的一些对象活动
