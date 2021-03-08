//
//  AnalysisCell.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/3/5.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit


import ZJTableViewManager

class AnalysisCellItem: ZJTableViewItem {
    ///解析答案
    var answerInfo: String?
}

class AnalysisCell: UITableViewCell, ZJCellProtocol {
    
    var item: AnalysisCellItem!
    
    typealias Item = AnalysisCellItem
    
    private var answerImgs: [String]?
    private var analysisImgs: [String]?
    
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
//        if let name = item.iconUrl {
//            img.image = UIImage(named: name)
//        }
//
//        if let num = item.index {
//            indexLab.text = num
//        }
//        if let msg = item.msg {
//            title.text = msg
//        }
        
        answerImgs = ["tabbar_home"]
        analysisImgs = ["tabbar_home"]

        if let arr = answerImgs{
            answerIconView.setImg(imgs: arr)
        }
        if let arr = analysisImgs{
            analysisIconView.setImg(imgs: arr)
        }
        layoutSubviews()
    }
    
    //MARK: - ui
    private func setUI() {
        contentView.addSubview(bg)
        bg.addSubview(answerTitleLab)
        bg.addSubview(answerInfoLab)
        bg.addSubview(answerIconView)
        bg.addSubview(line)
        bg.addSubview(analysisTitleLab)
        bg.addSubview(analysisInfoLab)
        bg.addSubview(analysisIconView)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        answerTitleLab.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        answerInfoLab.snp.makeConstraints { (make) in
            make.top.equalTo(answerTitleLab.snp_bottom).offset(10)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        answerIconView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo((answerImgs?.count ?? 0) * 80)
            make.top.equalTo(answerInfoLab.snp_bottom).offset(10)
        }
        line.snp.makeConstraints { (make) in
            make.top.equalTo(answerIconView.snp_bottom).offset(10)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        analysisTitleLab.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp_bottom).offset(10)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        analysisInfoLab.snp.makeConstraints { (make) in
            make.top.equalTo(analysisTitleLab.snp_bottom).offset(10)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        var analysisH = 0
        if analysisImgs != nil {
            analysisH = (analysisImgs?.count ?? 0) * 80
        }
        analysisIconView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(analysisH)
            make.top.equalTo(analysisInfoLab.snp_bottom).offset(10)
        }
        bg.snp.makeConstraints { (make) in
            make.bottom.equalTo(analysisIconView.snp_bottom).offset(10)
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
    
    lazy var answerTitleLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 15)
        lab.text = "【答案】"
        lab.textColor = UIColor(hexString: "#12AC88")
        return lab
    }()
    
    lazy var answerInfoLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 15)
        lab.numberOfLines = 0
        lab.text = "参考答案：B"
        return lab
    }()
    
    lazy var answerIconView: IconView = {
        let view = IconView()
        return view
    }()
    
    lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(hexString: "#E1EDE9")
        return line
    }()
    
    lazy var analysisTitleLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 15)
        lab.text = "【解析】"
        lab.textColor = UIColor(hexString: "#12AC88")
        return lab
    }()
    
    lazy var analysisInfoLab: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 15)
        lab.numberOfLines = 0
        lab.text = "本题考核财务报告。此题属于基础的考核点，这里大家在平时学习过程中应多注重总结，考试时这种题目也会出现，要拿到相应的分值哦"
        return lab
    }()
    
    lazy var analysisIconView: IconView = {
        let view = IconView()
        return view
    }()
    
    lazy var analysisIcon: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
}

class IconView: UIView {
    
    var icons: [String] = []

    func setImg(imgs: [String]) {
        icons = imgs
        _ = subviews.map {
            $0.removeFromSuperview()
        }
        for (index, item) in icons.enumerated() {
            let icon = UIImageView()
            icon.contentMode = .scaleAspectFit
            icon.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(touchImage(tap:)))
            icon.addGestureRecognizer(tap)
            icon.image = UIImage(named: item)
            addSubview(icon)
            icon.snp.makeConstraints { (make) in
                make.top.equalTo(index * 80)
                make.left.right.equalTo(15)
                make.height.equalTo(80)
                make.centerX.equalToSuperview()
            }
        }
    }
    
    @objc func touchImage(tap: UITapGestureRecognizer) {
        //TODO: -查看大图
        print("-查看大图")
    }
}
