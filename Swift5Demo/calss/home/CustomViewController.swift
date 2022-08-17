//
//  CustomViewController.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/7/7.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit

class CustomViewController: BaseViewController {

    var type: Int = 0
    
    var block: ((String)-> ())?
    
    init(type: Int) {
        super.init(nibName: nil, bundle: nil)
        self.type = type
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        
        var name = ""
        block = { [weak self] s in
            self?.type = 10
            name = s
            print(name)
        }
        block?("test block")
        let a = sum(true)(10)
        print(a)
    }
    
    func sum(_ bool: Bool) -> (Int) -> Int {
        func next(_ input: Int) -> Int {
            input + 1
        }
        
        func previous(_ input: Int) -> Int {
            input - 1
        }
        return bool ? next : previous
    }
}

class Categrory: CustomViewController {
    
}

extension CustomViewController {
    
}
