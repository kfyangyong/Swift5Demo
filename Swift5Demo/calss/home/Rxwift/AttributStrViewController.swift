//
//  AttributStrViewController.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/5/27.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class AttributStrViewController: BaseViewController {

    let disposBag = DisposeBag()
    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        button.frame = CGRect(x: 20, y: 100, width: 200, height: 50)
        button.backgroundColor = .yellow
        view.addSubview(button)
        

        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        timer.map(formatTimeInterval(ms:))
            .bind(to: button.rx.attributedTitle())
            .disposed(by: disposBag)
        
    }
    
    func formatTimeInterval(ms: NSInteger) -> NSMutableAttributedString {
        let str = String(format: "%0.2d:%0.2d.%0.2d", arguments: [(ms / 600) % 600, (ms % 600) / 10, ms % 10])
        let attr = NSMutableAttributedString(string: str)
        attr.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16), range: NSMakeRange(0, 5))
        attr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSMakeRange(0, 5))
        return attr
    }
    

}
