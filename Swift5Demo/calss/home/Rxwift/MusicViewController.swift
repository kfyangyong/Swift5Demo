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
    
    //RxSwift计数问题
    // 内部序列响应，不被外界影响
    fileprivate var mySubject = PublishSubject<Any>()
    var publicOB : Observable<Any>{
        // 重置激活
        mySubject = PublishSubject<Any>()
        return mySubject.asObservable()
    }
    
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
        
        tableView.rx.modelSelected(Music.self)
            .subscribe { music in
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
        testBehaviorRelay()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mySubject.onNext(12)
    }
    
    
    //BehaviorRelay替换原来的Variable
    //可以储存一个信号
    //随时订阅响应
    //响应发送的时候要注意：behaviorR.accept(20)
    func testBehaviorRelay() {
        let behaviorRelay = BehaviorRelay(value: 100)
        behaviorRelay.subscribe {  (num) in
            print(num)
        }.disposed(by: disposeBag)
        print("打印:\(behaviorRelay.value)")
        behaviorRelay.accept(20)
        behaviorRelay.accept(202)
        behaviorRelay.accept(201)
        /*
         next(100)
         打印:100
         next(20)
         next(202)
         next(201)
         */
    }
    
    // AsyncSubject
    //只发送由源Observable发送的最后一个事件，并且只在源Observable完成之后。
    func testAsyncSubject() {
        // 1:创建序列
        let asynSub = AsyncSubject<Int>.init()
        // 2:发送信号
        asynSub.onNext(1)
        asynSub.onNext(2)
        // 3:订阅序列
        asynSub.subscribe{ print("订阅到了:",$0)}
            .disposed(by: disposeBag)
        // 再次发送
        asynSub.onNext(3)
        asynSub.onNext(4)
        //        asynSub.onError(NSError.init(domain: "lgcooci", code: 10086, userInfo: nil))
        asynSub.onCompleted()
        /*
         订阅到了: next(4)
         订阅到了: completed
         */
    }
    
    func testReplaySubject() {
        // 1:创建序列
        // bufferSize 缓存的空间
//        let replaySub = ReplaySubject<Int>.create(bufferSize: 2)
        
         let replaySub = ReplaySubject<Int>.createUnbounded()

        // 2:发送信号
        replaySub.onNext(1)
        replaySub.onNext(2)
        replaySub.onNext(3)
        replaySub.onNext(4)

        // 3:订阅序列
        replaySub.subscribe{ print("订阅到了:",$0)}
            .disposed(by: disposeBag)
        // 再次发送
        replaySub.onNext(7)
        replaySub.onNext(8)
        replaySub.onNext(9)
        
        /*
         bufferSize: 2
         订阅到了: next(3)
         订阅到了: next(4)
         订阅到了: next(7)
         订阅到了: next(8)
         订阅到了: next(9)
         
         //createUnbounded
         订阅到了: next(1)
         订阅到了: next(2)
         订阅到了: next(3)
         订阅到了: next(4)
         订阅到了: next(7)
         订阅到了: next(8)
         订阅到了: next(9)
         */
        
        // AsyncSubject
        // 1:创建序列
        let asynSub = AsyncSubject<Int>.init()
        // 2:发送信号
        asynSub.onNext(1)
        asynSub.onNext(2)
        // 3:订阅序列
        asynSub.subscribe{ print("订阅到了:",$0)}
            .disposed(by: disposeBag)
        // 再次发送
        asynSub.onNext(3)
        asynSub.onNext(4)
        //        asynSub.onError(NSError.init(domain: "lgcooci", code: 10086, userInfo: nil))
        asynSub.onCompleted()

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
