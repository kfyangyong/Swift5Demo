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
import RxDataSources

class RxTableViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tab = UITableView(frame: view.bounds, style: .grouped)
        tab.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tab.delegate = self
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
        
        // 单组
        listModel.data.bind(to: tableView.rx.items(cellIdentifier: "UITableViewCell")) { index, music, cell in
            cell.textLabel?.text = "\(music.name ?? "**")--\(music.singer ?? "**")"
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(MusicModel.self).subscribe(onNext: { [weak self] music in
            print("选中歌曲：\(music.name ?? "**")--\(music.singer ?? "**")")
        }).disposed(by: disposeBag)
        
        //同时获取选中项的索引及内容也是可以的：
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(MusicModel.self))
            .bind { [weak self] index, music in
                print("选中行\(index)")
                print("选中歌曲：\(music.name ?? "**")--\(music.singer ?? "**")")
                if index.row == 0 {
                    let vc = AttributStrViewController()
                    self?.navigationController?.pushViewController(vc, animated: true)
                    return
                }
                let vc = RxTableSectionsViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
                
            }.disposed(by: disposeBag)
        
        tableView.rx.itemDeleted.subscribe { [weak self] index in
            print("删除行\(index)")
        }.disposed(by: disposeBag)
        
        tableView.rx.modelDeleted(MusicModel.self).subscribe { [weak self] data in
            let music = data.element
            print("删除歌曲：\(music?.name ?? "**")--\(music?.singer ?? "**")")
        }.disposed(by: disposeBag)
        
        
    }
    
    var data: Data?
}

extension RxTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
}


//MARK: - 调度器、subscribeOn、observeOn
/*
 Schedulers 主要控制任务在那个线程 或队列运行
 CurrentTherdScheduler: 当前线程
 MainScheduler 主线程
 SerialDispatchQueueScheduler cgd串行队列
 ConcurrentDispatchQueueScheduler gcd并行队列
 OperationQueueScheduler
 */
extension RxTableViewController {
    func test() {
        let url = ""
        //        DispatchQueue.global(qos: .userInitiated).async {
        //            let data = try? Data(contentsOf: NSURL(string: url) as! URL)
        //            DispatchQueue.main.async {
        //
        //            }
        //        }
        
        //rx实现
        //该方法决定在哪个 Scheduler 上监听这个数据序列。
        //subscribeOn 将其切换到后台 Scheduler 来执行。这样可以避免主线程被阻塞。
        let data: Data = try! Data(contentsOf: NSURL(string: url)! as URL)
        let rxData: Observable<Data> = Observable<Data>.from([data])
        rxData.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] data in
                self?.data = data
            }.disposed(by: disposeBag)
        
    }
}

//MARK: - 特征序列3：ControlProperty、 ControlEvent

/* ControlProperty
 * 是专门用来描述 UI 控件属性，拥有该类型的属性都是被观察者（Observable）。
 * 具有以下特征：
 * 不会产生 error 事件
 * 一定在 MainScheduler 订阅（主线程订阅）
 * 一定在 MainScheduler 监听（主线程监听）
 * 共享状态变化
 */
extension Reactive where Base: UITextField {
    
    public var text: ControlProperty<String?> {
        return value
    }
    
    public var value: ControlProperty<String?> {
        return base.rx.controlProperty(editingEvents: UIControlEvents(),
                                       getter: { textField in
                                        textField.text
                                       },setter: { textField, value in
                                        if textField.text != value {
                                            textField.text = value
                                        }
                                       }
        )
    }
    
}

/* ControlEvent 和 ControlProperty 一样，都具有以下特征：
 不会产生 error 事件
 一定在 MainScheduler 订阅（主线程订阅）
 一定在 MainScheduler 监听（主线程监听）
 共享状态变化
 
 extension Reactive where Base: UIButton {
 public var tap: ControlEvent<Void> {
 return controlEvent(.touchUpInside)
 }
 }
 */


struct MusicModel: IdentifiableType {
    public typealias Identity = String
    public var identity: String {
        return "MusicModel"
    }
    var name: String?
    var singer: String?
}

struct ListModel {
    let data = Observable.just( [
        MusicModel(name: "大风吹", singer: "流行区"),
        MusicModel(name: "泡沫", singer: "邓紫棋"),
        MusicModel(name: "七里香", singer: "周杰伦"),
    ]
    )
    
    let datas = Observable.just([
        SectionModel(model: "", items: [
            MusicModel(name: "大风吹", singer: "流行区"),
            MusicModel(name: "泡沫", singer: "邓紫棋"),
            MusicModel(name: "七里香", singer: "周杰伦"),
        ]),
        SectionModel(model: "", items: [
            MusicModel(name: "我这一生", singer: "半吨兄弟"),
            MusicModel(name: "半生雪", singer: "是七叔呢"),
            MusicModel(name: "七里香", singer: "周杰伦"),
        ])
    ])
}

/*
 subscribeOn()
 该方法决定数据序列的构建函数在哪个 Scheduler 上运行。
 比如上面样例，由于获取数据、解析数据需要花费一段时间的时间，所以通过 subscribeOn 将其切换到后台 Scheduler 来执行。这样可以避免主线程被阻塞。
 observeOn()
 该方法决定在哪个 Scheduler 上监听这个数据序列。
 比如上面样例，我们获取并解析完毕数据后又通过 observeOn 方法切换到主线程来监听并且处理结果。
 let rxData: Observable<Data> = ...
 
 rxData
 .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated)) //后台构建序列
 .observeOn(MainScheduler.instance)  //主线程监听并处理序列结果
 .subscribe(onNext: { [weak self] data in
 self?.data = data
 })
 .disposed(by: disposeBag)
 
 原文链接：https://www.hangge.com/blog/cache/detail_1940.html
 */

