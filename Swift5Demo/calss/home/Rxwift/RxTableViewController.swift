//
//  RxTableViewController.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/5/17.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxTableViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tab = UITableView(frame: view.bounds, style: .grouped)
        tab.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
//        tab.delegate = self
//        tab.dataSource = self
        return tab
    }()
    let listModel = ListModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        listModel.data.bind(to: tableView.rx.items(cellIdentifier: "UITableViewCell")) { index, music, cell in
            cell.textLabel?.text = "\(music.name ?? "**")--\(music.singer ?? "**")"
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Music.self).subscribe(onNext: { music in
            print("选中歌曲：\(music.name ?? "**")--\(music.singer ?? "**")")
        }).disposed(by: disposeBag)
        
    }
    
    
    

}

struct MusicModel {
    var name: String?
    var singer: String?
}
struct ListModel {
    let data = Observable.just([
        MusicModel(name: "大风吹", singer: "流行区"),
        MusicModel(name: "泡沫", singer: "邓紫棋"),
        MusicModel(name: "七里香", singer: "周杰伦"),
    ])
}
