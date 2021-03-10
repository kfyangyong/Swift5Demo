//
//  BottomViewController.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/3/8.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit
import ZJTableViewManager

class BottomView: UIView {

    var manager: ZJTableViewManager?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        configTab()
        initData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func configTab() {
    
        manager = ZJTableViewManager(tableView: self.tableView)
        tableView.separatorStyle = .none
        //register cell
        manager?.register(TiTitleCell.self, TiTitleCellItem.self)
        manager?.register(TiLableCell.self, TiLableCellItem.self)
        manager?.register(TiImageCell.self, TiImageCellItem.self)
        manager?.register(OptionAnswerCell.self, OptionAnswerCellItem.self)
        //add section
        let section = ZJTableViewSection(headerHeight: 10, color: UIColor.red)
        self.manager?.add(section: section)
    }
    
    func initData() {
        
        // 添加分类数据
        let categorySection = ZJTableViewSection()
        manager?.add(section: categorySection)
    
        let titleCellItem = TiTitleCellItem()
        titleCellItem.title = "A1型题(单句型最佳选择题)"
        categorySection.add(item: titleCellItem)
        
        let lableCellItem = TiLableCellItem()
        lableCellItem.title = "关于氧化磷酸化的叙述，错误的是"
        categorySection.add(item: lableCellItem)
        
        let optionItem1 = OptionAnswerCellItem()
        optionItem1.msg = "氧化磷酸化过程涉及两种呼吸链"
        optionItem1.index = "A"
        optionItem1.autoHeight(manager!)
        categorySection.add(item: optionItem1)

        let optionItem2 = OptionAnswerCellItem()
        optionItem2.iconUrl = "tabbar_home"
        optionItem2.msg = "物质在氧化时伴有ADP磷酸化生成ATP的过程"
        optionItem2.index = "B"
        optionItem2.autoHeight(manager!)
        categorySection.add(item: optionItem2)

        let optionItem3 = OptionAnswerCellItem()
        optionItem3.iconUrl = "tabbar_home"
        optionItem3.msg = "物质在氧化时伴有ADP磷酸化生成ATP的过程"
        optionItem3.index = "C"
        optionItem3.autoHeight(manager!)
        categorySection.add(item: optionItem3)
        
        let optionItem4 = OptionAnswerCellItem()
        optionItem4.iconUrl = "tabbar_home"
        optionItem4.msg = "物质在氧化时伴有ADP磷酸化生成ATP的过程"
        optionItem4.index = "D"
        optionItem4.autoHeight(manager!)
        categorySection.add(item: optionItem4)
        
    }
    
    //MARK: - lazy
    lazy var tableView: UITableView = {
        let tab = UITableView(frame: bounds, style: .plain)
        tab.estimatedRowHeight = 60
        tab.rowHeight = UITableView.automaticDimension
        return tab
    }()
    
}
