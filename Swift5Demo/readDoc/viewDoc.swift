//
//  viewDoc.swift
//  Swift5Demo
//
//  Created by 阿永 on 2022/11/7.
//  Copyright © 2022 com.ayong.myapp. All rights reserved.
//

import Foundation

//MARK: -frame与center bounds的关系
/*
 frame属性是相对于父容器的定位坐标。
 bounds属性针对于自己，指明大小边框，默认点为（0，0），而宽和高与frame宽和高相等。
 center属性是针对与frame属性的中心点坐标。
 当frame变化时，bounds和center相应变化。
 当bounds变化时，frame会根据新bounds的宽和高，在不改变center的情况下，进行重新设定。
 center永远与frame相关，指定frame的中心坐标！
 */
