//
//  TiBaseViewController.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/3/8.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit
import JXSegmentedView

enum ExamStatus {
    case doExam
    case read
    case error
    case analysis
}

class TiBaseViewController: BaseViewController {

    /// 默认章节练习
    var type: ExamStatus = .doExam
    
    weak var superVC: UIViewController?
    
    convenience init(supVC: UIViewController?) {
        self.init()
        superVC = supVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewLayout()
    }
    
    private func setViewLayout() {
        
        view.backgroundColor = .orange
    }
    
}
extension TiBaseViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
}
