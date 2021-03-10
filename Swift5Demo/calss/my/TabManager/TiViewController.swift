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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    private func setUI() {
        
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(0)
            $0.height.equalTo(300)
        }
        
        view.addSubview(listContainerView)
        listContainerView.snp.makeConstraints{
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
        return subVC
    }
    
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
//        return self.items.count
        return 10
    }
}
