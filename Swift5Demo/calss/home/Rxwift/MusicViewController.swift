//
//  MusicViewController.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/3/30.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MusicViewController: BaseViewController {
    
    let musicViewModel = MusicListViewModel()
    //负责对象销毁
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        
        musicViewModel.data.bind(to: tableView.rx.items(cellIdentifier: "UITableViewCell")) {
            print($0)
            print($1)
            print($2)
            $2.textLabel?.text = $1.name
            $2.detailTextLabel?.text = $1.singer
            
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Music.self).subscribe { music in
            print("选中歌曲\(music)")
        }
        
        
        let lab = UILabel()
        lab.textAlignment = .center
        lab.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(lab)
        lab.snp.makeConstraints { (make) in
            make.top.equalTo(200)
            make.left.right.equalTo(0)
        }
        
        //创建一个计时器（每1秒发送一个索引数）
        let timer = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)

        //根据索引数拼接最新的标题，并绑定到button上
        timer.map{self.formatTimeInterval(ms: $0)}
            .bind(to: lab.rx.attributedText)
            .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "停止", style: .done, target: self, action: #selector(endTimer))
        
        
        let segmented = UISegmentedControl()
        segmented.tintColor = .blue
        view.addSubview(segmented)
        segmented.snp.makeConstraints { (make) in
            make.top.equalTo(lab.snp.bottom).offset(10)
            make.height.equalTo(30)
            make.centerX.equalToSuperview()
        }
        
        
    }
    //将数字转成对应的富文本
        func formatTimeInterval(ms: NSInteger) -> NSMutableAttributedString {
            let string = String(format: "%0.2d:%0.2d.%0.2d",
                                arguments: [(ms / 600) % 600, (ms % 600 ) / 10, ms % 10])
            //富文本设置
            let attributeString = NSMutableAttributedString(string: string)
            //从文本0开始6个字符字体HelveticaNeue-Bold,16号
            attributeString.addAttribute(NSAttributedString.Key.font,
                                         value: UIFont(name: "HelveticaNeue-Bold", size: 16)!,
                                         range: NSMakeRange(0, 5))
            //设置字体颜色
            attributeString.addAttribute(NSAttributedString.Key.foregroundColor,
                                         value: UIColor.white, range: NSMakeRange(0, 5))
            //设置文字背景颜色
            attributeString.addAttribute(NSAttributedString.Key.backgroundColor,
                                         value: UIColor.orange, range: NSMakeRange(0, 5))
            return attributeString
        }
    
    @objc func endTimer() {
        
    }
    
    lazy var tableView: UITableView = {
        let tab = UITableView(frame: view.bounds, style: .grouped)
        tab.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return tab
    }()

}

import RxSwift
 
//歌曲列表数据源
struct MusicListViewModel {
    let data = Observable.just([
        Music(name: "无条件", singer: "陈奕迅"),
        Music(name: "你曾是少年", singer: "S.H.E"),
        Music(name: "从前的我", singer: "陈洁仪"),
        Music(name: "在木星", singer: "朴树"),
    ])
}

struct Music {
    var name: String?
    var singer: String?
}
