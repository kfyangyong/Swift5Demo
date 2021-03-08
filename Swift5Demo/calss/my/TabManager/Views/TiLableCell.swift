//
//  TiLableCell.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/3/4.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit
import ZJTableViewManager

class TiLableCellItem: ZJTableViewItem {
    var title: String!
    
}

///题目 材料文字 试题材料内容
class TiLableCell: UITableViewCell, ZJCellProtocol {
    var item: TiLableCellItem!
    
    typealias ZJCelltemClass = TiLableCellItem
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - manager
    func cellWillAppear() {
        title.text = item.title
    }
    
    
    //MARK: - ui
    private func setUI() {
        contentView.addSubview(title)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        title.snp.makeConstraints { (make) in
            make.edges.left.equalTo(15)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(-15)
        }
    }
    
    lazy var title: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 15)
        lab.numberOfLines = 0
        lab.text = "1.试题材料内容"
        return lab
    }()
}
