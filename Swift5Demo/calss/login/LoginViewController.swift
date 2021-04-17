//
//  LoginViewController.swift
//  Swift5Demo
//
//  Created by 杨永 on 2019/9/25.
//  Copyright © 2019 com.ayong.myapp. All rights reserved.
//

import UIKit
import RxSwift
class LoginViewController: BaseViewController {
    let disposBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setRX()
    }
    
    func setRX() {
        let nameValid = nameTF.rx.text.orEmpty.map {
            $0.count > 5
        }.share(replay: 1)
        
        let pwdValid = pwdTF.rx.text.orEmpty.map {
            $0.count > 5
        }.share(replay: 1)
        
        let everythingValid = Observable.combineLatest(
            nameValid,
            pwdValid
        ) { $0 && $1 }
        .share(replay: 1)
        
        nameValid.bind(to: pwdTF.rx.isEnabled).disposed(by: disposBag)
        everythingValid.bind(to: login.rx.isEnabled).disposed(by: disposBag)
        login.rx.tap.subscribe(onDisposed:  {
            print("开始登录")
        }).disposed(by: disposBag)
    }
    
    //MARK: - ui
    func setUI() {
        view.addSubview(nameTF)
        view.addSubview(pwdTF)
        view.addSubview(login)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nameTF.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.centerY.equalToSuperview().offset(-100)
            make.height.equalTo(44)
        }
        pwdTF.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(44)
            make.top.equalTo(nameTF.snp_bottom).offset(20)
        }
        login.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(44)
            make.top.equalTo(pwdTF.snp_bottom).offset(20)
        }
    }
    
    private lazy var nameTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "账号"
        tf.backgroundColor = .yellow
        return tf
    }()
    private lazy var pwdTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "密码"
        tf.backgroundColor = .yellow
        return tf
    }()
    
    private lazy var login: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .blue
        btn.setTitle("登录", for: .normal)
        return btn
    }()
}
