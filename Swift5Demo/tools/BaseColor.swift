//
//  BaseColor.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/7/31.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit

extension UIColor: CactusCompatible {}
extension Cactus where Base == UIColor {
    
    static var mainColor: UIColor {
        UIColor(hexString: "#A64742")
    }
    
    static var bgColor: UIColor {
        .white
    }
    
}
