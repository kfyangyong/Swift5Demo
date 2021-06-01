//
//  DriverViewController.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/5/17.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// Driver 使用一个 UI 元素值（绑定）来驱动另一个 UI 元素值
//不会产生 error 事件
//一定在主线程监听（MainScheduler）
//共享状态变化（shareReplayLatestWhileConnected）
class DriverViewController: BaseViewController {
    
    let disposbag = DisposeBag()
    let msg = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "table", style: .done, target: self, action: #selector(barclick))
        view.addSubview(msg)
        msg.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        //        base()
        //        customRx()
        //        subjectsRx()
        
        changeCharRx()
        testCombine()
        Connectable()
    }
    
    @objc func barclick() {
        let vc = RxTableViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func base() {
        
        let observable = Observable<Any>.create { (anyObserver) -> Disposable in
            anyObserver.onNext("发送响应")
            anyObserver.onCompleted()
            return Disposables.create()
        }
        
        observable.subscribe { text in
            print("收到响应 \(text)")
        }.disposed(by: disposbag)
        
        //创建 observable 序列
        /*
         1、just()方法
         2、of（）方法
         3、frome（）方法
         4、empty() 方法
         5、never()
         6、error()
         7、range()
         8、repeatElement()
         9、generate()
         10、creat()
         11、deferred()
         12 interval() 方法
         13 timer()
         
         */
        
        let observable1 = Observable<Int>.just(4)
        let observable2 = Observable.of("a","b","c")
        observable2.subscribe { e in
            print("onnext: \(e)")
        } onError: { err in
            print(err)
        } onCompleted: {
            print("onCompleted")
        } onDisposed: {
            print("onDisposed")
        }.disposed(by: disposbag)
        
        
        let observable3 = Observable.from(["a","b","c"])
        //（1）我们可以使用 doOn 方法来监听事件的生命周期，它会在每一次事件发送前被调用。
        //        （2）同时它和 subscribe 一样，可以通过不同的 block 回调处理不同类型的 event。比如：
        //        do(onNext:) 方法就是在 subscribe(onNext:) 前调用
        //        而 do(onCompleted:) 方法则会在 subscribe(onCompleted:) 前面调用。
        
        observable3
            .do(onNext: { element in
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
            }).disposed(by: disposbag)
        
        let observable4 = Observable<Int>.empty()
        let observable5 = Observable<Int>.never()
        
        let observable6 = Observable<Int>.error(Myerror.a)
        
        //等价于 Observable.of(1,2,3,4,5)
        let observable7 = Observable.range(start: 1, count: 5)
        
        
        //方法创建一个可以无限发出给定元素的 Event 的 Observable 序列（永不终止）
        let observable8 = Observable.repeatElement(1)
        
        let observable9 = Observable.generate(initialState: 0) {
            $0 <= 10
        } iterate: {
            $0 + 10
        }
        
        // Observable 序列每隔一段设定的时间，会发出一个索引数的元素。而且它会一直发送下去。
        let observable12 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable12.subscribe { event in
            print(event)
        }
        
        //Observable 序列在经过设定的一段时间后，产生唯一的一个元素
        let observable13 = Observable<Int>.timer(5, scheduler: MainScheduler.instance)
        observable13.subscribe { event in
            print("observable13 订阅 \(event)")
        }.disposed(by: disposbag)
        // Observable 序列在经过设定的一段时间后，每隔一段时间产生一个元素
        //延时5秒种后，每隔1秒钟发出 period 个元素
        
        let observable13_2 = Observable<Int>.timer(5, period: 1, scheduler: MainScheduler.instance)
        observable13_2.subscribe { event in
            print("observable13_2 订阅 \(event)")
        }.disposed(by: disposbag)
        
        
        
        /* 观察者（Observer）
         * 作用就是监听事件，然后对这个事件做出响应。或者说任何响应事件的行为都是观察者
         * 1、在 subscribe 方法中创建
         * 2、在 bind 方法中创建
         * 3、AnyObserver 可以用来描叙任意一种观察者。
         * 4、使用 Binder 创建观察者
         */
        observable13_2.map {
            "当前索引\($0)"
        }.bind { [weak self] text in
            self?.msg.text = text
        }.disposed(by: disposbag)
        
        let observer: AnyObserver<String> = AnyObserver { e in
            switch e {
            case .next(let data):
                print(data)
            case .error(let err):
                print(err)
            case .completed:
                print("AnyObserver completed")
            }
        }
        let observableAny = Observable.from(["a","b","c"])
        //配合 subscribe 方法使用
        observableAny.subscribe(observer)
        
        //配合 Observable 的数据绑定方法（bindTo）使用
        
        //使用 Binder 创建观察者
        //不会处理错误事件
        // 确保绑定都是在给定 Scheduler 上执行（默认 MainScheduler）
        let observerB = Binder(msg) { (view, text) in
            view.text = text
        }
        
        let observable_b = Observable<Int>.range(start: 10, count: 20)
        observable_b.map { "当前信息：\($0)" }
            .bind(to: observerB)
            .disposed(by: disposbag)
        
    }
    
    func customRx() {
        
        //1、自定义属性
        //Observable序列（每隔0.5秒钟发出一个索引数）
        //        let observable = Observable<Int>.interval(0.5, scheduler: MainScheduler.instance)
        //        observable.map { CGFloat($0) }
        //            .bind(to: msg.fontSize) //根据索引数不断变放大字体
        //            .disposed(by: disposbag)
        
        // 2、通过对 Reactive 类进行扩展
        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable.map { CGFloat($0) }
            .bind(to: msg.rx.fontsize) //根据索引数不断变放大字体
            .disposed(by: disposbag)
    }
    
    //MARK: -Subjects
    /*
     一共有四种 Subjects，
     分别为：PublishSubject、BehaviorSubject、ReplaySubject、Variable。
     他们之间既有各自的特点，也有相同之处
     
     首先他们都是 Observable，他们的订阅者都能收到他们发出的新的 Event。
     直到 Subject 发出 .complete 或者 .error 的 Event 后，该 Subject 便终结了，同时它也就不会再发出 .next 事件。
     对于那些在 Subject 终结后再订阅他的订阅者，也能收到 subject 发出的一条 .complete 或 .error 的 event，告诉这个新的订阅者它已经终结了。
     他们之间最大的区别只是在于：当一个新的订阅者刚订阅它的时候，能不能收到 Subject 以前发出过的旧 Event，如果能的话又能收到多少个。
     
     onNext(:)：是 on(.next(:)) 的简便写法。该方法相当于 subject 接收到一个 .next 事件。
     onError(:)：是 on(.error(:)) 的简便写法。该方法相当于 subject 接收到一个 .error 事件。
     onCompleted()：是 on(.completed) 的简便写法。该方法相当于 subject 接收到一个 .completed 事件。
     */
    
    
    func subjectsRx() {
        //PublishSubjectRx()
        //BehaviorSubjectRx()
        replaySubjectRx()
    }
    
    func PublishSubjectRx() {
        //PublishSubject 的订阅者只能收到他们订阅后的 Event。
        //创建一个PublishSubject
        let subject = PublishSubject<String>()
        
        //由于当前没有任何订阅者，所以这条信息不会输出到控制台
        subject.onNext("111")
        
        //第1次订阅subject
        subject.subscribe(onNext: { string in
            print("第1次订阅：", string)
        }, onCompleted:{
            print("第1次订阅：onCompleted")
        }).disposed(by: disposbag)
        
        //当前有1个订阅，则该信息会输出到控制台
        subject.onNext("222")
        
        //第2次订阅subject
        subject.subscribe(onNext: { string in
            print("第2次订阅：", string)
        }, onCompleted:{
            print("第2次订阅：onCompleted")
        }).disposed(by: disposbag)
        
        //当前有2个订阅，则该信息会输出到控制台
        subject.onNext("333")
        
        //让subject结束
        subject.onCompleted()
        
        //subject完成后会发出.next事件了。
        subject.onNext("444")
        
        //subject完成后它的所有订阅（包括结束后的订阅），都能收到subject的.completed事件，
        subject.subscribe(onNext: { string in
            print("第3次订阅：", string)
        }, onCompleted:{
            print("第3次订阅：onCompleted")
        }).disposed(by: disposbag)
    }
    
    //需要通过一个默认初始值来创建。
    //
    func BehaviorSubjectRx() {
        let subject = BehaviorSubject(value: "111")
        subject.subscribe { event in
            print("第1次订阅：\(event)")
        }.disposed(by: disposbag)
        
        subject.onNext("222")
        subject.onError(NSError(domain: "local", code: 0, userInfo: nil))
        
        subject.subscribe { event in
            print("第2次订阅：\(event)")
        }
        subject.onNext("333")
        subject.onCompleted()
        subject.subscribe { event in
            print("第3次订阅：\(event)")
        }
        
        //        第1次订阅：next(111)
        //        第1次订阅：next(222)
        //        第1次订阅：error(Error Domain=local Code=0 "(null)")
        //        第2次订阅：error(Error Domain=local Code=0 "(null)")
        //        第3次订阅：error(Error Domain=local Code=0 "(null)")
        // error 释放了序列
        
    }
    
    //ReplaySubject 在创建时候需要设置一个 bufferSize，表示它对于它发送过的 event 的缓存个数。
    func replaySubjectRx() {
        //创建一个bufferSize为2的ReplaySubject
        // bufferSize 订阅前的 event 缓存个数
        let subject = ReplaySubject<String>.create(bufferSize: 2)
        
        //连续发送3个next事件
        subject.onNext("111")
        subject.onNext("222")
        subject.onNext("333")
        
        //第1次订阅subject 缓存两个 222 333
        subject.subscribe { event in
            print("第1次订阅：", event)
        }.disposed(by: disposbag)
        
        //再发送1个next事件 后续正常
        subject.onNext("444")
        subject.onNext("555")
        //第2次订阅subject
        subject.subscribe { event in
            print("第2次订阅：", event)
        }.disposed(by: disposbag)
        
        //让subject结束
        subject.onCompleted()
        
        //第3次订阅subject
        subject.subscribe { event in
            print("第3次订阅：", event)
        }.disposed(by: disposbag)
        //        第1次订阅： next(222)
        //        第1次订阅： next(333)
        //        第1次订阅： next(444)
        //        第2次订阅： next(333)
        //        第2次订阅： next(444)
        //        第1次订阅： completed
        //        第2次订阅： completed
        //        第3次订阅： next(333)
        //        第3次订阅： next(444)
        //        第3次订阅： completed
    }
    
    //Variable 废弃
    
    // BehaviorRelay
    // BehaviorSubject 的功能，能够向它的订阅者发出上一个 event 以及之后新创建的 event。
    //不需要也不能手动给 BehaviorReply 发送 completed 或者 error 事件来结束它（BehaviorRelay 会在销毁时也不会自动发送 .complete 的 event）
    func behaviorRelayRx() {
        //创建一个初始值为111的BehaviorRelay
        let subject = BehaviorRelay<String>(value: "111")
        
        //修改value值
        subject.accept("222")
        
        //第1次订阅
        subject.asObservable().subscribe {
            print("第1次订阅：", $0)
        }.disposed(by: disposbag)
        
        //修改value值
        subject.accept("333")
        
        //第2次订阅
        subject.asObservable().subscribe {
            print("第2次订阅：", $0)
        }.disposed(by: disposbag)
        
        //修改value值
        subject.accept("444")
    }
    
    
    //MARK: - 变换操作符：buffer、map、flatMap、scan
    
    func changeCharRx() {
        buffer()
        
        window()
        map()
        flatMap()
        flatMapLatest()
        concatMap()
        scan()
        groupBy()
        
        fliter()
        distinctUntilChanged()
    }
    
    func buffer() {
        let subject = PublishSubject<String>()
        subject.buffer(timeSpan: 1, count: 3, scheduler: MainScheduler.instance).subscribe { event in
            print(event)
        }.disposed(by: disposbag)
        
        subject.onNext("a")
        subject.onNext("a")
        subject.onNext("a")
        
        subject.onNext("b")
        subject.onNext("b")
        subject.onNext("b")
        
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
        subject.onNext("4")
        subject.onCompleted()
    }
    //window 周期性的将元素集合以 Observable 的形态发送出来。
    func window() {
        let subject = PublishSubject<String>()
        
        subject.window(timeSpan: 1, count: 3, scheduler: MainScheduler.instance)
            .subscribe { [weak self] in
                print("window subscribe \($0)")
                
            }.disposed(by: disposbag)
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("b")
        subject.onNext("b")
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
        subject.onNext("4")
        subject.onCompleted()
    }
    
    //map 传入一个函数闭包把原来的 Observable 序列转变为一个新的 Observable 序列
    func map() {
        Observable.of(1, 2, 3)
            .map { $0 * 10}
            .subscribe(onNext: { print($0) })
            .disposed(by: disposbag)
    }
    
    func flatMap() {
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        
        let variable = Variable(subject1)
        
        variable.asObservable()
            .flatMap { $0 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposbag)
        
        subject1.onNext("B")
        variable.value = subject2
        subject2.onNext("2")
        subject1.onNext("C")
    }
    
    //flatMapLatest 与 flatMap 的唯一区别是：flatMapLatest 只会接收最新的 value 事件。
    //flatMapFirst 与 flatMapLatest 正好相反：flatMapFirst 只会接收最初的 value 事件。
    func flatMapLatest() {
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        
        let variable = Variable(subject1)
        
        variable.asObservable()
            .flatMapLatest { $0 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposbag)
        
        subject1.onNext("B")
        variable.value = subject2
        subject2.onNext("2")
        subject1.onNext("C")
    }
    
    //concatMap 与 flatMap 的唯一区别是：当前一个 Observable 元素发送完毕后，后一个Observable 才可以开始发出元素。或者说等待前一个 Observable 产生完成事件后，才对后一个 Observable 进行订阅
    func concatMap() {
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        let variable = Variable(subject1)
        variable.asObservable()
            .concatMap { $0 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposbag)
        
        subject1.onNext("B")
        variable.value = subject2
        subject2.onNext("2")
        subject1.onNext("C")
        subject1.onCompleted() //只有前一个序列结束后，才能接收下一个序列
    }
    //scan 就是先给一个初始化的数，然后不断的拿前一个结果和最新的值进行处理操作。
    func scan() {
        Observable.of(1,2,3,4,5,6,7)
            .scan(0) { acum, element in
                acum + element
            }.subscribe {
                print($0)
            }.disposed(by: disposbag)
    }
    //groupBy 操作符将源 Observable 分解为多个子 Observable，然后将这些子 Observable 发送出来。
    func groupBy() {
        Observable.of(1,2,3,4,5,6,7)
            .groupBy(keySelector: { element in
                return element % 2 == 0 ? "偶数" : "基数"
            })
            .subscribe { (event) in
                switch event {
                case .next(let group):
                    group.asObservable().subscribe({ (event) in
                        print("key：\(group.key)    event：\(event)")
                    })
                    .disposed(by: self.disposbag)
                default:
                    print("")
                }
            }
            .disposed(by: disposbag)
    }
    
    //MARK: - 过滤操作符（Filtering Observables）
    //filter
    func fliter() {
        let disposeBag = DisposeBag()
        Observable.of(2, 30, 22, 5, 60, 3, 40 ,9)
            .filter {
                $0 > 10
            }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    //distinctUntilChanged
    func distinctUntilChanged() {
        let disposeBag = DisposeBag()
        
        Observable.of(2, 30, 22, 22, 5, 60, 60, 3, 40, 5, 30,9)
            .distinctUntilChanged()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    //single
    //限制只发送一次事件，或者满足条件的第一个事件。
    //如果存在有多个事件或者没有事件都会发出一个 error 事件。
    //如果只有一个事件，则不会发出 error 事件。
    func single() {
        let disposeBag = DisposeBag()
        Observable.of(2, 30, 22, 22, 5, 60, 60, 3, 40, 5, 30,9)
            .single{ $0 == 2 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    //elementAt
    //该方法实现只处理在指定位置的事件
    func elementAt() {
        let disposeBag = DisposeBag()
        Observable.of(2, 30, 22, 22, 5, 60, 60, 3, 40, 5, 30,9)
            .elementAt(2)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    //ignoreElements
    //该操作符可以忽略掉所有的元素，只发出 error 或 completed 事件。
    //如果我们并不关心 Observable 的任何元素，只想知道 Observable 在什么时候终止，那就可以使用 ignoreElements 操作符。
    func ignoreElements() {
        let disposeBag = DisposeBag()
        Observable.of(2, 30, 22, 22, 5, 60, 60, 3, 40, 5, 30,9)
            .ignoreElements()
            .subscribe{ print($0) }
            .disposed(by: disposeBag)
    }
    //take
    //该方法实现仅发送 Observable 序列中的前 n 个事件，在满足数量之后会自动 .completed。
    func take() {
        let disposeBag = DisposeBag()
        Observable.of(2, 30, 22, 22, 5, 60, 60, 3, 40, 5, 30,9)
            .take(5)
            .subscribe{ print($0) }
            .disposed(by: disposeBag)
    }
    
    //takeLast
    //该方法实现仅发送 Observable 序列中的后 n 个事件。
    func takeLast() {
        let disposeBag = DisposeBag()
        Observable.of(2, 30, 22, 22, 5, 60, 60, 3, 40, 5, 30,9)
            .takeLast(5)
            .subscribe{ print($0) }
            .disposed(by: disposeBag)
    }
    
    //skip
    //该方法用于跳过源 Observable 序列发出的前 n 个事件。
    func skip() {
        let disposeBag = DisposeBag()
        Observable.of(2, 30, 22, 22, 5, 60, 60, 3, 40, 5, 30,9)
            .skip(5)
            .subscribe{ print($0) }
            .disposed(by: disposeBag)
    }
    
    //Sample
    //Sample 除了订阅源 Observable 外，还可以监视另外一个 Observable， 即 notifier 。
    //每当收到 notifier 事件，就会从源序列取一个最新的事件并发送。而如果两次 notifier 事件之间没有源序列的事件，则不发送值。
    
    func sample() {
        let source = PublishSubject<Int>()
        let notifier = PublishSubject<String>()
        source.sample(notifier)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposbag)
        
        source.onNext(1)
        
        //让源序列接收接收消息
        notifier.onNext("A")
        
        source.onNext(2)
        
        //让源序列接收接收消息
        notifier.onNext("B")
        notifier.onNext("C")
        
        source.onNext(3)
        source.onNext(4)
        
        //让源序列接收接收消息
        notifier.onNext("D")
        
        source.onNext(5)
        
        //让源序列接收接收消息
        notifier.onCompleted()
    }
    
    //debounce
    //debounce 操作符可以用来过滤掉高频产生的元素，它只会发出这种元素：该元素产生后，一段时间内没有新元素产生。
    //换句话说就是，队列中的元素如果和下一个元素的间隔小于了指定的时间间隔，那么这个元素将被过滤掉。
    //debounce 常用在用户输入的时候，不需要每个字母敲进去都发送一个事件，而是稍等一下取最后一个事件。
    func debounce() {
        
        //定义好每个事件里的值以及发送的时间
        let times = [
            [ "value": 1, "time": 0.1 ],
            [ "value": 2, "time": 1.1 ],
            [ "value": 3, "time": 1.2 ],
            [ "value": 4, "time": 1.2 ],
            [ "value": 5, "time": 1.4 ],
            [ "value": 6, "time": 2.1 ]
        ]
        
        //生成对应的 Observable 序列并订阅
        Observable.from(times)
            .flatMap { item in
                return Observable.of(Int(item["value"]!))
                    .delaySubscription(Double(item["time"]!),
                                       scheduler: MainScheduler.instance)
            }
            .debounce(0.5, scheduler: MainScheduler.instance) //只发出与下一个间隔超过0.5秒的元素
            .subscribe(onNext: { print($0) })
            .disposed(by: disposbag)
    }
    
    
    //MARK: -条件和布尔操作符：amb、takeWhile、skipWhile
    //https://www.hangge.com/blog/cache/detail_1948.html
    //amb 当传入多个 Observables 到 amb 操作符时，它将取第一个发出元素或产生事件的 Observable，然后只发出它的元素。并忽略掉其他的 Observables
    func amb() {
        let disposeBag = DisposeBag()
        
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<Int>()
        let subject3 = PublishSubject<Int>()
        
        subject1
            .amb(subject2)
            .amb(subject3)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        subject2.onNext(1)
        subject1.onNext(20)
        subject2.onNext(2)
        subject1.onNext(40)
        subject3.onNext(0)
        subject2.onNext(3)
        subject1.onNext(60)
        subject3.onNext(0)
        subject3.onNext(0)
    }
    
    //takeWhile
    //该方法依次判断 Observable 序列的每一个值是否满足给定的条件。 当第一个不满足条件的值出现时，它便自动完成。
    func takeWhile() {
        let disposeBag = DisposeBag()
        Observable.of(2, 3, 4, 5, 6)
            .takeWhile { $0 < 4 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    //takeUntil
    //除了订阅源 Observable 外，通过 takeUntil 方法我们还可以监视另外一个 Observable， 即 notifier。
    //如果 notifier 发出值或 complete 通知，那么源 Observable 便自动完成，停止发送事件。
    func takeUntil() {
        let disposeBag = DisposeBag()
        
        let source = PublishSubject<String>()
        let notifier = PublishSubject<String>()
        
        source
            .takeUntil(notifier)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        source.onNext("a")
        source.onNext("b")
        source.onNext("c")
        source.onNext("d")
        
        //停止接收消息
        notifier.onNext("z")
        source.onNext("e")
        source.onNext("f")
        source.onNext("g")
    }
    //skipWhile
    //该方法用于跳过前面所有满足条件的事件。
    //一旦遇到不满足条件的事件，之后就不会再跳过了
    func skipWhile() {
        let disposeBag = DisposeBag()
        Observable.of(2, 3, 4, 5, 6)
            .skipWhile { $0 < 4 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    //skipUntil
    //除了订阅源 Observable 外，通过 skipUntil 方法我们还可以监视另外一个 Observable， 即 notifier 。
    //Observable 序列事件默认会一直跳过，直到 notifier 发出值或 complete 通知
    func skipUntil() {
        let disposeBag = DisposeBag()
        
        let source = PublishSubject<Int>()
        let notifier = PublishSubject<Int>()
        
        source
            .skipUntil(notifier)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        source.onNext(1)
        source.onNext(2)
        source.onNext(3)
        source.onNext(4)
        source.onNext(5)
        
        //开始接收消息
        notifier.onNext(0)
        
        source.onNext(6)
        source.onNext(7)
        source.onNext(8)
        
        //仍然接收消息
        notifier.onNext(0)
        source.onNext(9)
    }
}

//MARK: - 结合操作符：startWith、merge、zip
//https://www.hangge.com/blog/cache/detail_1930.html
extension DriverViewController {
    
    func testCombine() {
        zip()
    }
    //startWith
    //该方法会在 Observable 序列开始之前插入一些事件元素。即发出事件消息之前，会先发出这些预先插入的事件消息。
    func startWith() {
        let disposeBag = DisposeBag()
        Observable.of("2", "3")
            .startWith("1")
            .startWith("b")
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    //merge
    //该方法可以将多个（两个或两个以上的）Observable 序列合并成一个 Observable 序列。
    func merge() {
        let disposeBag = DisposeBag()
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<Int>()
        Observable.of(subject1, subject2)
            .merge()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        subject1.onNext(20)
        subject1.onNext(40)
        subject1.onNext(60)
        subject2.onNext(1)
        subject1.onNext(80)
        subject1.onNext(100)
        subject2.onNext(1)
    }
    
    //zip
    //该方法可以将多个（两个或两个以上的）Observable 序列压缩成一个 Observable 序列。
    //而且它会等到每个 Observable 事件一一对应地凑齐之后再合并
    func zip() {
        let disposeBag = DisposeBag()
        
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<String>()
        
        Observable.zip(subject1, subject2) {
            "\($0)\($1)"
        }
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
        
        subject1.onNext(1)
        subject2.onNext("A")
        subject1.onNext(2)
        subject2.onNext("B")
        subject2.onNext("C")
        subject2.onNext("D")
        subject1.onNext(3)
        subject1.onNext(4)
        subject1.onNext(5)
        
        //        1A
        //        2B
        //        3C
        //        4D
    }
    //combineLatest
    //该方法同样是将多个（两个或两个以上的）Observable 序列元素进行合并。
    //但与 zip 不同的是，每当任意一个 Observable 有新的事件发出时，它会将每个 Observable 序列的最新的一个事件元素进行合并
    func combineLatest() {
        let disposeBag = DisposeBag()
        
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<String>()
        
        Observable.combineLatest(subject1, subject2) {
            "\($0)\($1)"
        }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
        
        subject1.onNext(1)
        subject2.onNext("A")
        subject1.onNext(2)
        subject2.onNext("B")
        subject2.onNext("C")
        subject2.onNext("D")
        subject1.onNext(3)
        subject1.onNext(4)
        subject1.onNext(5)
    }
    //withLatestFrom
    //该方法将两个 Observable 序列合并为一个。每当 self 队列发射一个元素时，便从第二个序列中取出最新的一个值
    
    func withLatestFrom() {
        let disposeBag = DisposeBag()
        
        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()
        
        subject1.withLatestFrom(subject2)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        subject1.onNext("A")
        subject2.onNext("1")
        subject1.onNext("B")
        subject1.onNext("C")
        subject2.onNext("2")
        subject1.onNext("D")
    }
    
    //switchLatest
    //switchLatest 有点像其他语言的 switch 方法，可以对事件流进行转换。
    //比如本来监听的 subject1，我可以通过更改 variable 里面的 value 更换事件源。变成监听 subject2
    func switchLatest() {
        let subject1 =  BehaviorSubject(value: "A")
        let subject2 =  BehaviorSubject(value: "1")
        let variable = Variable(subject1)
        
        variable.asObservable()
            .switchLatest()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposbag)
        subject1.onNext("B")
        subject1.onNext("C")
        
        //改变事件源
        variable.value = subject2
        subject1.onNext("D")
        subject2.onNext("2")
        
        //改变事件源
        variable.value = subject1
        subject2.onNext("3")
        subject1.onNext("E")
    }
}

//MARK: - 算数&聚合操作符：toArray、reduce、concat
extension DriverViewController {
    func mathematical() {
        toarray()
    }
    
    func toarray() {
        let disposeBag = DisposeBag()
        Observable.of(1, 2, 3)
            .toArray()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    //reduce 接受一个初始值，和一个操作符号。
    //reduce 将给定的初始值，与序列里的每个值进行累计运算。得到一个最终结果，并将其作为单个值发送出去。
    func reduce() {
        let disposeBag = DisposeBag()
        Observable.of(1, 2, 3)
            .reduce(0 , accumulator: +)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    //concat
    //会把多个 Observable 序列合并（串联）为一个 Observable 序列。
    //并且只有当前面一个 Observable 序列发出了 completed 事件，才会开始发送下一个 Observable 序列事件
    func concat() {
        let disposeBag = DisposeBag()
        let subject1 = BehaviorSubject(value: 1)
        let subject2 = BehaviorSubject(value: 2)
        
        let variable = Variable(subject1)
        variable.asObservable()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        subject2.onNext(2)
        subject1.onNext(1)
        subject1.onNext(1)
        subject1.onCompleted()
        
        variable.value = subject2
        subject2.onNext(2)
        
    }
    
}

//MARK: - 连接操作符：connect、publish、replay、multicast
extension DriverViewController {
    func Connectable() {
        //        publish()
        replay()
    }
    
    //publish 方法会将一个正常的序列转换成一个可连接的序列。同时该序列不会立刻发送事件，只有在调用 connect 之后才会开始
    func publish() {
        //每隔1秒钟发送1个事件
        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .publish()
        
        //第一个订阅者（立刻开始订阅）
        _ = interval
            .subscribe(onNext: { print("订阅1: \($0)") })
        
        //相当于把事件消息推迟了两秒
        delay(2) {
            _ = interval.connect()
        }
        
        //第二个订阅者（延迟5秒开始订阅）
        delay(5) {
            _ = interval
                .subscribe(onNext: { print("订阅2: \($0)") })
        }
    }
    
    //replay
    //同上面的 publish 方法相同之处在于：会将将一个正常的序列转换成一个可连接的序列。同时该序列不会立刻发送事件，只有在调用 connect 之后才会开始。
    //replay 与 publish 不同在于：新的订阅者还能接收到订阅之前的事件消息（数量由设置的 bufferSize 决定）
    func replay() {
        //每隔1秒钟发送1个事件
        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .replay(5)
        
        //第一个订阅者（立刻开始订阅）
        _ = interval
            .subscribe(onNext: { print("订阅1: \($0)") })
        
        //相当于把interval 事件消息推迟了两秒
        delay(2) {
            _ = interval.connect()
        }
        
        //第二个订阅者（延迟5秒开始订阅）
        delay(5) {
            _ = interval
                .subscribe(onNext: { print("订阅2: \($0)") })
        }
    }
    //refCount
    
    //share(relay:)
    
    public func delay(_ delay: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
    
}

//MARK: - 其他操作符：delay、materialize、timeout
extension DriverViewController {
    //1，delay
    //该操作符会将 Observable 的所有元素都先拖延一段设定好的时间，然后才将它们发送出来。
    
    //delaySubscription
    //使用该操作符可以进行延时订阅。即经过所设定的时间后，才对 Observable 进行订阅操作。
    
    //materialize
    //该操作符可以将序列产生的事件，转换成元素。
    //通常一个有限的 Observable 将产生零个或者多个 onNext 事件，最后产生一个 onCompleted 或者 onError 事件。而 materialize 操作符会将 Observable 产生的这些事件全部转换成元素，然后发送出来
    
    //dematerialize
    //该操作符的作用和 materialize 正好相反，它可以将 materialize 转换后的元素还原。
    
    
    //timeout
    //使用该操作符可以设置一个超时时间。如果源 Observable 在规定时间内没有发任何出元素，就产生一个超时的 error 事件。
    
    // using
    //操作符创建 Observable 时，同时会创建一个可被清除的资源，一旦 Observable 终止了，那么这个资源就会被清除掉了
    func using() {
        //一个无限序列（每隔0.1秒创建一个序列数 ）
        let infiniteInterval$ = Observable<Int>
            .interval(0.1, scheduler: MainScheduler.instance)
            .do(
                onNext: { print("infinite$: \($0)") },
                onSubscribe: { print("开始订阅 infinite$")},
                onDispose: { print("销毁 infinite$")}
            )
        
        //一个有限序列（每隔0.5秒创建一个序列数，共创建三个 ）
        let limited$ = Observable<Int>
            .interval(0.5, scheduler: MainScheduler.instance)
            .take(2)
            .do(
                onNext: { print("limited$: \($0)") },
                onSubscribe: { print("开始订阅 limited$")},
                onDispose: { print("销毁 limited$")}
            )
        
        //使用using操作符创建序列
        let o: Observable<Int> = Observable.using {
            return AnyDisposable(infiniteInterval$.subscribe())
        } observableFactory: {_ in
            return limited$
        }
        o.subscribe()
    }
}

//MARK: - 错误处理操作
//通过将 RxSwift.Resources.total 打印出来，我们可以查看当前 RxSwift 申请的所有资源数量。这个在检查内存泄露的时候非常有用
extension DriverViewController {
    func testErr() {
        
    }
    
    func catchErrorJustReturn() {
        let sequenceThatFails = PublishSubject<String>()
        sequenceThatFails
            .catchErrorJustReturn("错误")
            .subscribe(onNext: { print($0) })
            .disposed(by: disposbag)
        
        sequenceThatFails.onNext("a")
        sequenceThatFails.onNext("b")
        sequenceThatFails.onNext("c")
        sequenceThatFails.onError(MyError.a)
        sequenceThatFails.onNext("d")
    }
    //retry
    //该方法当遇到错误的时候，会重新订阅该序列。比如遇到网络请求失败时，可以进行重新连接。
    // retry() 方法可以传入数字表示重试次数。不传的话只会重试一次
    func retry() {
        var count = 2
        let sequenceThatErrors = Observable<String>.create { observer in
            observer.onNext("a")
            observer.onNext("b")
            if count == 1 {
                observer.onError(Myerror.a)
                print("erroe pop")
                count += 1
            }
            observer.onNext("c")
            observer.onNext("d")
            observer.onCompleted()
            return Disposables.create()
        }
        
        sequenceThatErrors.retry(2)
            .debug()
            .subscribe {
                print($0)
            }.disposed(by: disposbag)
    }
}


//自定义属性
extension UILabel {
    var fontSize: Binder<CGFloat> {
        return Binder(self) { lab, fontSize in
            lab.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
}
// 通过对 Reactive 类进行扩展
extension Reactive where Base: UILabel {
    
    public var fontsize: Binder<CGFloat> {
        return Binder(self.base) { lab, fontSize in
            lab.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
}

/*
 ControlEvent
 是专门用于描述 UI 所产生的事件，拥有该类型的属性都是被观察者（Observable）。
 ControlEvent 和 ControlProperty 一样，都具有以下特征：
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
 


enum Myerror: Error {
    case a
    case b
}

class AnyDisposable: Disposable {
    let _dispose: () -> Void
    
    init(_ disposable: Disposable) {
        _dispose = disposable.dispose
    }
    
    func dispose() {
        _dispose()
    }
}
