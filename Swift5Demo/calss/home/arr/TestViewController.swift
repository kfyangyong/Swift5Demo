//
//  TestViewController.swift
//  Swift5Demo
//
//  Created by 杨永 on 2021/11/20.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        testArray()
        
    }
    
    //元组
    func testArray() {
        var arr:Array = ["tom1","tom2","tom3","tom4","tom2","tom3","tom2","tom3"]
        arr.append("ads")
        for name in arr {
            print(name)
        }
        for name in arr.sorted() {
            print( "sort: " + name)
        }

        var arr1:[Int] = [Int](repeating: 10, count: 9)
        for num in arr1 {
            print( "arr1: \(num)")
        }
        
        for (index, value) in arr.enumerated() {
            print( "arr: \(index) = " ,value)
        }
        //缓存容量
        arr.reserveCapacity(100)
    }


}
