//
//  BaseViewController.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/1/16.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit
import MBProgressHUD
import MJRefresh
import SnapKit
import RxSwift
import RxCocoa


class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    
    deinit {
        print(type(of: self))
    }

}
