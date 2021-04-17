//
//  RXViewController.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/4/1.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RXViewController: BaseViewController {

    var slider: UISlider!
    let disposeBag = DisposeBag()
    
    var textField: UITextField!
    var label: UILabel!
    var userVM = UserViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        slider = UISlider()
        slider.tintColor = .orange
        slider.maximumValue = 100
        slider.value = 10
        view.addSubview(slider)
        slider.snp.makeConstraints { (make) in
            make.top.equalTo(100)
            make.height.equalTo(20)
            make.width.equalTo(200)
            make.centerX.equalToSuperview()
        }
        slider.rx.value.asObservable()
            .subscribe {
                print("当前值为：\($0)")
            }.disposed(by: disposeBag)

        
        //双向绑定
        textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.yellow.cgColor
        view.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(slider.snp.bottom).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(200)
            make.left.equalTo(20)
        }
        label = UILabel()
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalTo(textField.snp.bottom).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(200)
            make.left.equalTo(20)
        }
        
        userVM.username.asObservable().bind(to: textField.rx.text).disposed(by: disposeBag)

        textField.rx.text.orEmpty.bind(to: userVM.username).disposed(by: disposeBag)
        userVM.userinfo.bind(to: label.rx.text).disposed(by: disposeBag)
    }
    
}


struct UserViewModel {
   //用户名
   let username = Variable("guest")
    
   //用户信息
   lazy var userinfo = {
       return self.username.asObservable()
           .map{ $0 == "Hanger" ? "您是管理员" : "您是普通访客" }
           .share(replay: 1)
   }()
}
