//
//  UIView_rxswift.swift
//  Swift5Demo
//
//  Created by 阿永 on 2022/4/14.
//  Copyright © 2022 com.ayong.myapp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// 自定义 observer UI观察者

/*
 usernameValid
     .bind(to: usernameValidOutlet.rx.isHidden)
     .disposed(by: disposeBag)
 */
extension Reactive where Base: UIView {
    public var isHidden: Binder<Bool> {
        return Binder(self.base) { view, hidden in
            view.isHidden = hidden
        }
    }
}

extension Reactive where Base: UIControl {
    public var isEnabled: Binder<Bool> {
        return Binder(self.base) { control, value in
            control.isEnabled = value
        }
    }
}


/*
 // 作为可监听序列
 let observable = textField.rx.text
 observable.subscribe { text in
     show(text:text)
 }
 
 // 作为响应者
 let observer = textField.rx.text
 let text:Observable<String?> = ...
 text.bind(to: observer)

 */

extension Reactive where Base: UILabel {
    public var text: Binder<String?> {
        return Binder(self.base) { lable, text in
            lable.text = text
        }
    }
}

//MARK: -  “既是可监听序列也是观察者”

//AsyncSubject 仅发出最后一个元素， 如果没有发出任何元素，只有一个完成事件

//PublishSubject “将对观察者发送订阅后产生的元素，而在订阅前发出的元素将不会发送给观察者”

//ReplaySubject “将对观察者发送全部的元素，无论观察者是何时进行订阅的”

//BehaviorSubject “它会将源 Observable 中最新的元素发送出来（如果不存在最新的元素，就发出默认元素）。然后将随后产生的元素发送出来。

//ControlProperty “
/*
 专门用于描述 UI 控件属性的，它具有以下特征：
 不会产生 error 事件
 一定在 MainScheduler 订阅（主线程订阅）
 一定在 MainScheduler 监听（主线程监听）”
 */

//MARK: - Operator - 操作符
import UIKit

extension UIView {
    
    //Schedulers
    func test() {
        let disposeBag = DisposeBag()
        
        DispatchQueue.global(qos: .userInitiated).async {
            let data = Data()
            DispatchQueue.main.async {
//                self.data = data
            }
        }
        
        //
        let rxData: Observable<Data> = Observable.create { _ in
            return Disposables.create {}
        }
//        rxData
//            .retry(3) //重试
//
//            .retryWhen { (rxError: Observable<Error>) -> Observable<Int> in
//                return Observable.timer(retryDelay, scheduler: MainScheduler.instance)
//            }//“这个操作符主要描述应该在何时重试，并且通过闭包里面返回的 Observable 来控制重试的时机”
//            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
//            .observeOn(MainScheduler.instance)
//            .subscribe { [weak self] data in
//
//            }.disposed(by: disposeBag)

    }
    
    
}




