//
//  PathViewController.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/2/21.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit

class PathViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        let home = NSHomeDirectory()
        print(home)
        
        //获取 ./Documents
        //用户文档目录，苹果建议将程序中建立的或在程序中浏览到的文件数据保存在该目录下，iTunes备份和恢复的时候会包括此目录
        let documentsPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentPath = documentsPaths.first!
        print(documentPath + "/n")
        let documentPath2 = NSHomeDirectory() + "/Documents"
        print(documentPath2 + "/n")

        
        //获取 ./library
        //这个目录下有两个子目录：Caches 和 Preferences
        //Library/Preferences目录，包含应用程序的偏好设置文件。不应该直接创建偏好设置文件，而是应该使用NSUserDefaults类来取得和设置应用程序的偏好。
        //Library/Caches目录，主要存放缓存文件，iTunes不会备份此目录，此目录下文件不会再应用退出时删除
        let libraryPaths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        let libPath = libraryPaths.first!
        print(libPath + "/n")
        let libPath2 = NSHomeDirectory() + "/Library"
        print(libPath2 + "/n")
        
        //获取 ./cache
        let cachePaths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let cache = cachePaths.first
        print(cache! + "/n")
        let cache2 = NSHomeDirectory() + "/Library/Caches"
        print(cache2 + "/n")
        
        //tmp目录  ./tmp
        //用于存放临时文件，保存应用程序再次启动过程中不需要的信息，重启后清空。
        let tmpDir = NSTemporaryDirectory()
        print(tmpDir)
        let tmpDir2 = NSHomeDirectory() + "/tmp"
        print(tmpDir2)
        
        //mainBundle
        //工程打包安装后会在NSBundle.mainBundle()路径下，该路径是只读的，不允许修改
        //声明一个Documents下的路径
        let dbPath = NSHomeDirectory() + "/Documents/hanggeDB.sqlite"
        print(dbPath)
        //判断数据库文件是否存在
        if !FileManager.default.fileExists(atPath: dbPath){
            //获取安装包内数据库路径
            let bundleDBPath:String = Bundle.main.path(forResource: "hanggeDB", ofType: "sqlite")!
            //将安装包内数据库拷贝到Documents目录下
            let bundleDBPathURL:URL = URL.init(string: "file://" + bundleDBPath)!
            try! FileManager.default.copyItem(at: bundleDBPathURL, to: URL.init(string: "file://" + dbPath)!)
        }
    }
    
    
    
    
}
