//
//  TiImageCell.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/3/4.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit
import ZJTableViewManager

class TiImageCellItem: ZJTableViewItem {
    var iconName: String?
    var bigImagBlock: (()->())?
}

///题目 材料文字 试题材料内容
class TiImageCell: UITableViewCell, ZJCellProtocol {
    var item: TiImageCellItem!
    
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
        guard let name = item.iconName else {
            return
        }
        img.image = UIImage(named: name)
    }
    
    @objc func btnclick(){
        item.bigImagBlock?()
    }
    
    
    //MARK: - ui
    private func setUI() {
        contentView.addSubview(img)
        contentView.addSubview(btn)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        img.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(-15)
            make.height.equalTo(80)
        }
        btn.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(-15)
            make.height.equalTo(80)
        }
    }
    
    lazy var img: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    lazy var btn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(btnclick), for: .touchUpInside)
        return btn
    }()
}

