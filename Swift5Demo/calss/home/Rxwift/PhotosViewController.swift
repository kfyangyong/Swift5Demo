//
//  PhotosViewController.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/2/22.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PhotosViewController: BaseViewController {
    var circleView: UIView!
    fileprivate var circleViewModel: CircleViewModel!
    fileprivate let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        aboutBtn()
        aboutText()
    }
    
    func setup() {
        // Add circle view
        circleView = UIView(frame: CGRect(origin: view.center, size: CGSize(width: 100.0, height: 100.0)))
        circleView.layer.cornerRadius = circleView.frame.width / 2.0
        circleView.center = view.center
        circleView.backgroundColor = .green
        view.addSubview(circleView)
        
        circleViewModel = CircleViewModel()
        circleView
            .rx.observe(CGPoint.self, "center")
            .bind(to: circleViewModel.centerVariable)
            .disposed(by: disposeBag)

        // Subscribe to backgroundObservable to get new colors from the ViewModel.
        circleViewModel.backgroundColorObservable
            .subscribe(onNext:{ [weak self] backgroundColor in
                UIView.animate(withDuration: 0.1) {
                    self?.circleView.backgroundColor = backgroundColor
                    let viewBackgroundColor = UIColor(complementaryFlatColorOf: backgroundColor)
                    if viewBackgroundColor != backgroundColor {
                        self?.view.backgroundColor = viewBackgroundColor
                    }
                }
            })
            .disposed(by: disposeBag)
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(circleMoved(_:)))
        circleView.addGestureRecognizer(gestureRecognizer)
    }
    
    func aboutBtn() {
        let button = UIButton()
        button.setTitle("k开始", for: .normal)
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.height.width.equalTo(100)
            make.left.bottom.equalTo(0)
        }
        button.rx.tap.subscribe { (btn) in
            let s = arc4random()%100
            button.setTitle(String(s), for: .normal)
        }.disposed(by: disposeBag)
    }
    
    func aboutText() {
        let tf = UITextField()
        view.addSubview(tf)
        tf.placeholder = "默认输入"
        tf.backgroundColor = .orange
        tf.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.bottom.equalTo(-40)
            make.right.equalToSuperview()
            make.height.equalTo(60)
        }
        tf.rx.text.orEmpty.changed.subscribe { (text) in
            print("我监听到了:\(text)")
        } onCompleted: {
            print("我结束了")
        }.disposed(by: disposeBag)

    }
    
    @objc func circleMoved(_ recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: view)
        UIView.animate(withDuration: 0.1) {
            self.circleView.center = location
        }
    }

}

enum MyError: Error {
    case a
    case b
}

extension PhotosViewController {
    
    func creatObser() {
     
        let observable = Observable.just(5)
        
        let ob1 = Observable.of("a","b","c")
        let ob2 = Observable.from(["a","b","c"])
        ob2.do(onNext: { element in
                print("Intercepted Next：", element)
            }, onError: { error in
                print("Intercepted Error：", error)
            }, onCompleted: {
                print("Intercepted Completed")
            }, onDispose: {
                print("Intercepted Disposed")
            })
            .subscribe(onNext: { element in
                print(element)
            }, onError: { error in
                print(error)
            }, onCompleted: {
                print("completed")
            }, onDisposed: {
                print("disposed")
            })
        
        let ob3 = Observable<Any>.empty()
        let ob4 = Observable<Any>.never()
        let ob5 = Observable<Any>.error(MyError.a)
        
        let ob6 = Observable.range(start: 0, count: 5)
        let ob7 = Observable.repeatElement(1)
        
        
        //该方法创建一个只有当提供的所有的判断条件都为 true 的时候，才会给出动作的 Observable 序列。
        let ob8 = Observable.generate(initialState: 0) {
            $0 <= 10
        } iterate: {
            $0 + 2
        }

        
        //这个block有一个回调参数observer就是订阅这个Observable对象的订阅者
        //当一个订阅者订阅这个Observable对象的时候，就会将订阅者作为参数传入这个block来执行一些内容
        let observable9 = Observable<String>.create{observer in
            //对订阅者发出了.next事件，且携带了一个数据"hangge.com"
            observer.onNext("hangge.com")
            //对订阅者发出了.completed事件
            observer.onCompleted()
            //因为一个订阅行为会有一个Disposable类型的返回值，所以在结尾一定要returen一个Disposable
            return Disposables.create()
        }
         
        //订阅测试
        observable9.subscribe {
            print($0)
        }
        
        //每 1 秒发送一次，并且是在主线程（MainScheduler）发送。
        let observable10 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable10.subscribe { event in
            print(event)
        }
    }
}
