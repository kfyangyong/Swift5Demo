//
//  HomeViewController.swift
//  Swift5Demo
//
//  Created by 杨永 on 2019/9/24.
//  Copyright © 2019 com.ayong.myapp. All rights reserved.
//

import UIKit
import MBProgressHUD


class HomeViewController: UIViewController {
    
    var titles: [String] = []
    lazy var tabview: UITableView = {
        let tab = UITableView(frame: view.bounds, style: .grouped)
        tab.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tab.delegate = self
        tab.dataSource = self
        return tab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tabview)
        titles =  ["可点击label - ActiveLabel",
                   "内购 - appPay",
                   "可点击label - ActiveLabel",
                   "待续。。。"]
    }
    
    
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabview.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = ActiveLabelViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let productId = "com.zhongyejingjishiTKT.taocan.7995"
            PayManager.shared.startPay(productId: productId)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}






