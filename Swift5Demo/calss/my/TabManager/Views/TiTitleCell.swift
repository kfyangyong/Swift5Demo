//
//  TiTitleCell.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/3/4.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit
import ZJTableViewManager

class TiTitleCellItem: ZJTableViewItem {
    var title: String!
    
}

///题目
class TiTitleCell: UITableViewCell , ZJCellProtocol {
    var item: TiTitleCellItem!
    
    typealias ZJCelltemClass = TiTitleCellItem
    
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
            make.left.equalTo(15)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(-15)
        }
    }
    
    lazy var title: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 15)
        lab.numberOfLines = 0
        lab.text = "1.试题材料内容"
        return lab
    }()
}
