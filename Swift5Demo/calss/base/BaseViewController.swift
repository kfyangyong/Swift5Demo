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

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    
    
    deinit {
        print(type(of: self))
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
