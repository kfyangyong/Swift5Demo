//
//  Api.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/1/29.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import Foundation
import RxSwift

class Api {
    
    /*
     func test() {
         let disposebag = DisposeBag()
         getRepo("reactiveX/Rxswift")
             .subscribe { json in
                 print("json", json)
             } onError: { err in
                 print("Error", err)
             }.disposed(by: disposebag)
     }
     */
    //创建single “它要么只能发出一个元素，要么产生一个 error 事件
    func getRepo(_ repo: String)-> Single<[String:Any]> {
        
        return Single<[String:Any]>.create { single in
            let url = URL(string: "")!
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
               if let error = error {
                   single(.error(error))
                   return
               }
                guard let data = data, let json = try? JSONSerialization.data(withJSONObject: data), let result = json as? [String: Any] else {
//                    single(.error())
                    return
                }
                single(.success(result))
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    //创建Completable 它要么只能产生一个 completed 事件，要么产生一个 error 事件”
    //适用于那种你只关心任务是否完成，而不需要在意任务返回值的情况
    func completableTest() -> Completable {
        return Completable.create { completable in
            let success = arc4random()%2 == 0
            guard success else {
//                completable(.error())
                return Disposables.create{}
            }
            completable(.completed)
            return Disposables.create { }
        }
    }
    
    func testCompletable() {
        let disposebag = DisposeBag()
        completableTest().subscribe {
            print("completed")
        } onError: { err in
            print("err")
        }.disposed(by: disposebag)
    }
    
    //Maybe “它要么只能发出一个元素，要么产生一个 completed 事件，要么产生一个 error 事件”
   
    func maybeTask()->Maybe<String> {
        return Maybe<String>.create { maybe in
            maybe(.success("maybe success")) as! Disposable
            //or
//            maybe(.error("err"))*
            
            return Disposables.create {
            }
        }
    }
    
    // Driver “不会产生 error 事件 一定在 MainScheduler 监听（主线程监听）”
    
    
}
