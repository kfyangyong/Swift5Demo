//
//  DispatchSourceTest.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/1/28.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import Foundation

class DispatchSourceTest {
    var filePath: String = ""
    var counter = 0
    let queue = DispatchQueue.global()
    
    init() {
        filePath = "\(NSTemporaryDirectory())"
        
    }
    
    func startObserve(closure: @escaping ()->Void) {
        let fileUrl = URL(fileURLWithPath: filePath)
        let monitoredDirectoryFileDescriptor = open(fileUrl.path, O_EVTONLY)
        let source = DispatchSource.makeFileSystemObjectSource(fileDescriptor: monitoredDirectoryFileDescriptor, eventMask: .write, queue: queue)
        source.setEventHandler {
            
        }
        source.setCancelHandler {
            
        }
        source.resume()
    }
    
    func chagefile() {
        DispatchSourceTest.creatFile(name: "DispatchSourceTest.md", filePath: NSTemporaryDirectory())
        counter += 1
        let text = "\(counter)"
        try! text.write(toFile:"\(filePath)/DispatchSourceTest.md", atomically: true, encoding: .utf8)
        print("file writed")
    }
    
    
    static func creatFile(name: String, filePath: String) {
        let manager = FileManager.default
        let fileBaseUrl = URL(fileURLWithPath: filePath)
        let file = fileBaseUrl.appendingPathComponent(name)
        print("文件 \(file)")
        
        let exist = manager.fileExists(atPath: filePath)
        if !exist {
            let data = Data(base64Encoded: "appendingPathComponent", options: .ignoreUnknownCharacters)
            let createSuccess = manager.createFile(atPath: filePath, contents: data, attributes: nil)
            print("文件创建结果 \(createSuccess)")
        }
        
    }
}
