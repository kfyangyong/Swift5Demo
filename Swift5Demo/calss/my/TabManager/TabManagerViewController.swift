//
//  TabManagerViewController.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/3/4.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit
import ZJTableViewManager

protocol TabManagerMovePro: class {
    func Move(topH: CGFloat)
}


class TabManagerViewController: TiBaseViewController {

    var manager: ZJTableViewManager?
    var titleHeader: UIView!
    weak var delegate: TabManagerMovePro?
    
    private var anchorPoint: UserResizableViewAnchorPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        configTab()
        initData()
    }
    
    func setUI() {
        titleHeader = UIView()
        titleHeader.backgroundColor = .green;
        titleHeader.isUserInteractionEnabled = true
        view.addSubview(titleHeader)
        titleHeader.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(44)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleHeader.snp_bottom)
            make.left.right.bottom.equalTo(0)
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
        manager?.register(AnalysisCell.self, AnalysisCellItem.self)
        //add section

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
        
    
        let imgItem = TiImageCellItem()
        imgItem.iconName = "tabbar_home"
        imgItem.bigImagBlock = {
            print("imgItem.bigImagBlock")
        }
        categorySection.add(item: imgItem)

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
        optionItem4.selectionHandler = { [weak self] _ in
            
        }
        
        
        let answerItem = AnalysisCellItem()
        answerItem.answerInfo = "答案"
        answerItem.autoHeight(manager!)
        categorySection.add(item: answerItem)
    }
    
    //MARK: - lazy
    lazy var tableView: UITableView = {
        let tab = UITableView(frame: view.bounds, style: .plain)
        tab.estimatedRowHeight = 60
        tab.rowHeight = UITableView.automaticDimension
        return tab
    }()

}

extension TabManagerViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: superVC?.view) else {
            return
        }
        
//        let pointS = touches.first?.location(in: view)
        print(point)
//        print(pointS)
        delegate?.Move(topH: point.y)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
