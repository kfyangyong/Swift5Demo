//
//  aboutCollection.swift
//  Swift5Demo
//
//  Created by 阿永 on 2022/11/7.
//  Copyright © 2022 com.ayong.myapp. All rights reserved.
//

import Foundation

//MARK: - 有关collection itemsize 平分宽度间隙问题
/// 处理办法
/*
 /**
  *  @brief 取模之后再分配多余的像素，去除平分cell的缝隙.
  *
  *  @param displayWidth  显示的宽度范围（一般是屏幕宽度）
  *  @param col 显示的列数
  *  @param space 列间隔宽度（可以在这里设置，也可以在collection的回调函数中设置）
  *  @param indexPath cell的indexPath
  *
  *  @return 本cell的size
  *
  *  iPhone 6的屏幕是 750.
  *  col = 4，space = 0；
  *  750 % 4 = 2；
  *  (750 - 2) /4= 187;
  *  每一行的结果
  *  [188,188,187,187];
  *
  */
 - (CGSize)fixSizeBydisplayWidth:(float)displayWidth col:(int)col space:(int)space sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
     float pxWidth = displayWidth * [UIScreen mainScreen].scale;
     pxWidth = pxWidth - space * (col - 1);
     int mo = (int)pxWidth % col;  //余的不被整除值
     if (mo != 0) {
         // 屏幕宽度不可以平均分配
         float fixPxWidth = pxWidth - mo;
         float itemWidth = fixPxWidth / col;
         // 高度取最高的，所以要加1
         float itemHeight = itemWidth + 1.0;
         if (indexPath.row % col < mo) {
             // 模再分配给左边的cell，直到分配完为止
             itemWidth = itemWidth + 1.0;
         }
         NSNumber *numW = @(itemWidth / [UIScreen mainScreen].scale);
         NSNumber *numH = @(itemHeight / [UIScreen mainScreen].scale);
         return CGSizeMake(numW.floatValue, numH.floatValue);
     }else {
         // 屏幕可以平均分配
         float itemWidth = pxWidth / col;
         return CGSizeMake(itemWidth / [UIScreen mainScreen].scale, itemWidth / [UIScreen mainScreen].scale);
     }
 }
 */
