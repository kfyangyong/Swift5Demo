//
//  OptionAnswerCell.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/3/4.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit
import ZJTableViewManager

class OptionAnswerCellItem: ZJTableViewItem {
    var iconUrl: String?
    var msg: String?
    var index: String?
}

class OptionAnswerCell: UITableViewCell, ZJCellProtocol {

    var item: OptionAnswerCellItem!
    
    typealias Celltem = OptionAnswerCellItem
    
    private let ItemTitles = ["A","B","C","D","E","F","G","H","I","J","K","L"]
    
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
        if let name = item.iconUrl {
            img.image = UIImage(named: name)
        }
        
        if let num = item.index {
            indexLab.text = num
        }
        if let msg = item.msg {
            title.text = msg
        }
        layoutSubviews()
    }
    
    //MARK: - ui
    private func setUI() {
        contentView.addSubview(bg)
        bg.addSubview(indexLab)
        bg.addSubview(title)
        bg.addSubview(img)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        indexLab.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.width.equalTo(35)
            make.height.equalTo(39)
        }
        
        title.snp.makeConstraints { (make) in
            make.left.equalTo(47)
            make.top.equalTo(20)
            make.right.equalTo(-5)
        }
        var imgH = 0
        if img.image != nil {
            imgH = 80
        }
        img.snp.makeConstraints { (make) in
            make.left.equalTo(47)
            make.top.equalTo(title.snp_bottom).offset(10)
            make.right.equalTo(-5)
            make.height.equalTo(imgH)
        }
        bg.snp.makeConstraints { (make) in
            make.bottom.equalTo(img.snp_bottom).offset(10)
            make.bottom.equalTo(-10)
            make.left.equalTo(15)
            make.top.equalTo(10)
            make.right.equalTo(-15)
        }
    }
    
    lazy var bg: UIView = {
        let bg = UIView()
        bg.layer.cornerRadius = 10
        bg.backgroundColor = UIColor(hexString: "#EFF5F3")
        return bg
    }()
    
    lazy var indexLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 15)
        if let img = UIImage(named: "answermark_normal") {
            lab.backgroundColor = UIColor(patternImage: img)
        }
        lab.textColor = .white
        lab.textAlignment = .center
        return lab
    }()
    
    lazy var title: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 15)
        lab.numberOfLines = 0
        lab.text = "选项"
        return lab
    }()
    
    lazy var img: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        return icon
    }()

}
