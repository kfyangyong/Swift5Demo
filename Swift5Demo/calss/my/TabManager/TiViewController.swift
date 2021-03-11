//
//  TiViewController.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/3/8.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit
import JXSegmentedView

class TiViewController: BaseViewController {
    
    var items:[TiModel] = []
    
    //是否分两层
    var hadBottom: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    private func setUI() {
        view.addSubview(bottomView)
        view.addSubview(listContainerView)
        initLayout()
    }
    
    func initLayout() {
        let bottomH = hadBottom ? 300 : 0
        bottomView.snp.remakeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(0)
            $0.height.equalTo(bottomH)
        }
        listContainerView.snp.remakeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(bottomView.snp_bottom)
            $0.bottom.equalToSuperview()
        }
    }
    
    private lazy var bottomView:BottomView = {
        let vc = BottomView()
        return vc
    }()
    
    private lazy var listContainerView: JXSegmentedListContainerView = {
        let listContainerView = JXSegmentedListContainerView(dataSource: self)
        return listContainerView
    }()
}

/// MARK: - JXSegmentedListContainerViewDataSource
extension TiViewController: JXSegmentedListContainerViewDataSource {
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        let subVC = TabManagerViewController()
        subVC.delegate = self
        if ((index/2) == 0) {
            hadBottom = true
        }else {
            hadBottom = false
        }
        initLayout()
        return subVC
    }
    
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
//        return self.items.count
        return 10
    }
}

extension TiViewController: TabManagerMovePro {
    func Move(topH: CGFloat) {
        guard topH > 0, hadBottom else {
            return
        }
        bottomView.snp.updateConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(0)
            $0.height.equalTo(topH)
        }
        
        listContainerView.snp.updateConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(bottomView.snp_bottom)
            $0.bottom.equalToSuperview()
        }
    }
}
