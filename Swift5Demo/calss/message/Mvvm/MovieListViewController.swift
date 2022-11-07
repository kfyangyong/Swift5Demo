//
//  MovieListViewController.swift
//  Swift5Demo
//
//  Created by 杨永 on 2021/10/14.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit

class MovieListViewController: BaseViewController {
    
    enum Resources {
        case placeholder
        var path: String {
            switch self {
            case .placeholder:
                return "answermark_normal"
            }
        }
    }
    
    var datas: [String] = []
    
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


extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = "tabmanage vc"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TiViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

