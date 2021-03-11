//
//  SortView.swift
//  TestSort
//
//  Created by 天机否 on 17/3/28.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

import UIKit

struct Stack<Element> {
    private var array = [Element]()
 
    mutating func push(_ obj: Element) {
        array.append(obj)
    }
 
    mutating func pop() -> Element? {
        array.popLast()
    }
}

extension Stack {
    func sorted() -> [Element] where Element: Comparable {
        array.sorted()
    }
}

class SortView: UIView {

    var arr:[UInt32] = [] {
        didSet {
         self.setNeedsLayout()
         self.layoutIfNeeded()
        }
    }
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
                var index  = 0
                self.arr.forEach({ (height) in
                    if let tagView = self.viewWithTag(1000  + index) {
                        tagView.frame = CGRect.init(x: CGFloat(index*3), y: self.bounds.height - CGFloat(height), width: 2, height: CGFloat(height))
                    }else{
                        let view = UIView.init(frame: CGRect.init(x: CGFloat(index*3), y: self.bounds.height - CGFloat(height), width: 2, height: CGFloat(height)))
                        view.backgroundColor = UIColor.orange
                        view.tag = 1000 + index
                        self.addSubview(view)
                        
                    }
                    
                    index += 1
            })
    }
}
