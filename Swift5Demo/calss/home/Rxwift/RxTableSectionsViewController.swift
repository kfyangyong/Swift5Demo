//
//  RxTableSectionsViewController.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/5/27.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources


class RxTableSectionsViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tab = UITableView(frame: view.bounds, style: .grouped)
        tab.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tab.delegate = self
        //        tab.dataSource = self
        return tab
    }()
    let listModel = ListModel()
    
    var dataSource:RxTableViewSectionedReloadDataSource<MySection>?
    
    let datas = Observable.just([
        MySection(header: "流行曲",
                  items: [
                    MusicModel(name: "大风吹", singer: "流行区"),
                    MusicModel(name: "泡沫", singer: "邓紫棋"),
                    MusicModel(name: "七里香", singer: "周杰伦"),
                  ]),
        MySection(header: "抖音曲",
                  items: [
                    MusicModel(name: "我这一生", singer: "半吨兄弟"),
                    MusicModel(name: "半生雪", singer: "是七叔呢"),
                    MusicModel(name: "七里香", singer: "周杰伦"),
                  ])
    ])
    
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        //        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, MusicModel>> { dataSource, tableView, indexPath, element in
        //            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        //            cell?.textLabel?.text = "\(element.name ?? "**")--\(element.singer ?? "**")"
        //            return cell!
        //        }
        
        
        //        listModel.datas.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        dataSource = RxTableViewSectionedReloadDataSource<MySection>(
            configureCell: { ds, tv, ip, item in
                let cell = tv.dequeueReusableCell(withIdentifier: "UITableViewCell")
                    ?? UITableViewCell(style: .default, reuseIdentifier: "UITableViewCell")
                cell.textLabel?.text = "\(item.name ?? "**")--\(item.singer ?? "**")"
                return cell
                
            }) { info, index in
            return info[index].header
        }
        
        datas.bind(to: tableView.rx.items(dataSource: dataSource!)).disposed(by: disposeBag)
        tableView.rx.modelSelected(MusicModel.self).subscribe(onNext: { [weak self] music in
            print("选中歌曲：\(music.name ?? "**")--\(music.singer ?? "**")")
            let vc = AttributStrViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
            
        }).disposed(by: disposeBag)
        
    }
    
    deinit {
        print(#file, #function)
    }
    
}

extension RxTableSectionsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .yellow
        let lab = UILabel()
        lab.text = dataSource?[section].header
        lab.textColor = .black
        view.addSubview(lab)
        lab.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

//MARK: - 自定义 section

struct MySection {
    var header: String
    var items: [MusicModel]
}

extension MySection : SectionModelType {
    typealias Item = MusicModel
    
    var identity: String {
        return header
    }
    
    init(original: MySection, items: [Item]) {
        self = original
        self.items = items
    }
}
