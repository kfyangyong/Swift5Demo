//
//  MessageViewController.swift
//  Swift5Demo
//
//  Created by 杨永 on 2019/9/24.
//  Copyright © 2019 com.ayong.myapp. All rights reserved.
//

import UIKit

struct ItemModel {
    var name: String?
    var vc: UIViewController = UIViewController()
}

class MessageViewController: BaseViewController {
    
    var datas: [ItemModel] = [
        ItemModel(name: "base string", vc: StringViewController())
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    lazy var tableView: UITableView = {
        let tab = UITableView(frame: view.bounds, style: .grouped)
        tab.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tab.delegate = self
        tab.dataSource = self
        return tab
    }()
    
    
}


extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let model: ItemModel = datas[indexPath.row]
        cell.textLabel?.text = model.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model: ItemModel = datas[indexPath.row]
        let vc = model.vc
        navigationController?.pushViewController(vc, animated: true)
    }
}
