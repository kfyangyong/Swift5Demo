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

extension BaseViewController {
    func showErrorAlter(_ title: String?, message: String) {
        let alter = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "ok", style: .default) { result in
            print("showErrorAlter \(message)")
        }
        alter.addAction(action)
        self.present(alter, animated: true)
    }
    
    func showSuccessAlter(_ title: String?, message: String) {
        let alter = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "ok", style: .default) { result in
            print("showErrorAlter \(message)")
        }
        alter.addAction(action)
        self.present(alter, animated: true)
    }
    
    func dataStartLoding() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func dataFinishedLoading() {
        MBProgressHUD.hide(for: self.view, animated: true)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
