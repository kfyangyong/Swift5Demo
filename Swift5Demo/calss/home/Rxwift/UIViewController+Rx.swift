//
//  UIViewController+Rx.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/5/19.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


public extension Reactive where Base: UIViewController {
    
    var viewDidload: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewWillAppear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear(_:))).map { _ in
        }
        return ControlEvent(events: source)
    }
    
    var viewDidAppear: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.viewDidAppear(_:))).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewWillDisappear: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.viewWillDisappear(_:))).map{_ in }
        return ControlEvent(events: source)
    }
    
    var viewDidDisappear: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.viewDidDisappear(_:))).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewWillLayoutSubviews: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.viewWillLayoutSubviews)).map { _ in }
        return ControlEvent(events: source)
    }
    var viewDidLayoutSubviews: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.viewDidLayoutSubviews)).map { _ in }
        return ControlEvent(events: source)
    }
    
    var willMove: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.willMove(toParent:))).map { _ in }
        return ControlEvent(events: source)
    }
    var didMove: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.didMove(toParent:))).map { _ in }
        return ControlEvent(events: source)
    }
    var didReceiveMemoryWarning: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.didReceiveMemoryWarning)).map { _ in }
        return ControlEvent(events: source)
    }
    
    var dismiss: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.dismiss(animated:completion:))).map { _ in }
        return ControlEvent(events: source)
    }
    
    var isVisiable: Observable<Bool> {
        let viewDidAppearObservable = self.base.rx.viewDidAppear.map { _ in
            true
        }
        let viewwillDisAppearObservable = self.base.rx.viewWillDisappear.map { _ in
            false
        }
        return Observable<Bool>.merge(viewDidAppearObservable,viewwillDisAppearObservable)
    }
    
}
