//
//  DispatchIO.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/1/29.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import Foundation

//DispatchIO 提供一个操作文件描述符的通道
// 创建DispatchIO 对象，并设置结束处理闭包
// 调用 read/ write 方法
//调用 close关闭， 系统自动结束处理闭包

class DispatchIOManager {
    
    /// 利用很小的内存空间及同一队列读写方式合并文件
    static func combineFileWithOneQueue() {
        let files: [String] = ["/Users/ayong/Downloads/gcd.mp4.zip.001","/Users/ayong/Downloads/gcd.mp4.zip.002"]
        let outFile: String = "/Users/ayong/Downloads/gcd.mp4.zip"
        let ioQueue = DispatchQueue(label: "com.DispatchIOManager.queue")
        let queueGroupe = DispatchGroup()
        let ioWriteCleaanupHandler:(Int32) -> Void = {_ in
            print("写入文件完成 \(Date())")
        }
        let ioReadCleaanupHandler:(Int32) -> Void = {_ in
            print("读文件完成 \(Date())")
        }
        
//        let ioWrite = DispatchIO(type: .stream, path: outFile.utf8CString, oflag: (O_RDWR|O_CREAT|O_APPEND)), mode: (S_IRWXU), queue: ioQueue, cleanupHandler: ioWriteCleaanupHandler）
        
    }
}
