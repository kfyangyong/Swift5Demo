//
//  HomeViewController.swift
//  Swift5Demo
//
//  Created by 杨永 on 2019/9/24.
//  Copyright © 2019 com.ayong.myapp. All rights reserved.
//

import UIKit
import MBProgressHUD
import RxSwift

class HomeViewController: UIViewController {
    
    var titles: [String] = []
    lazy var tabview: UITableView = {
        let tab = UITableView(frame: view.bounds, style: .grouped)
        tab.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tab.delegate = self
        tab.dataSource = self
        return tab
    }()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tabview)
        titles =  ["可点击label - ActiveLabel",
                   "内购 - appPay",
                   "视频播放器",
                   "GCD线程",
                   "LottieViewController",
                   "文件路径",
                   "rxswift PhotosViewController",
                   "PaixuViewController",
                   "LoginViewController",
                   "MusicViewController",
                   "RXViewController",
                   "DriverViewController",
                   "TestViewController"]
        
        
        print("********emty********")
        
        var emtyOb = Observable<Int>.empty()
        _ = emtyOb.subscribe(onNext: { (number) in
            print("订阅:",number)
        }, onError: { (error) in
            print("error:",error)
        }, onCompleted: {
            print("完成回调")
        }) {
            print("释放回调")
        }
    
        print("********just********")
        //MARK:  just
        // 单个信号序列创建
        let array = ["LG_Cooci","LG_Kody"]
//        Observable<[String]>.just(array)
//            .subscribe { (event) in
//                print("event" + "\(event)")
//            }.disposed(by: disposeBag)

        _ = Observable<[String]>.just(array).subscribe(onNext: { (number) in
            print("订阅:",number)
        }, onError: { (error) in
            print("error:",error)
        }, onCompleted: {
            print("完成回调")
        }) {
            print("释放回调")
        }

    }
    
    
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabview.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = ActiveLabelViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let productId = "com.zhongyejingjishiTKT.taocan.7995"
            PayManager.shared.startPay(productId: productId)
            PayManager.shared.showMsg = { _ in
                self.tabview.reloadData()
            }
        case 2:
            let vc = YYPlayViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = GCDViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc = AniViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true) {
            }
        case 5:
            let vc = PathViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 6:
            let vc = PhotosViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 7:
            let vc = PaixuViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 8:
            let vc = LoginViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 9:
            let vc = MusicViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 10:
            let vc = RXViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 11:
            let vc = DriverViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            let vc = TestViewController()
            navigationController?.pushViewController(vc, animated: true)
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}






