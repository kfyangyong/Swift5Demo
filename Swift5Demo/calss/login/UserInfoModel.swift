//
//  UserInfoModel.swift
//  Swift5Demo
//
//  Created by 杨永 on 2019/9/25.
//  Copyright © 2019 com.ayong.myapp. All rights reserved.
//

import UIKit


struct UserInfoModel:Codable {
    var code:StrInt
    var data:UserInfoData
    
    struct UserInfoData : Codable{
        var stateCode:StrInt
        var message:String
        var returnData:DMReturnData
    }
    
    struct DMReturnData: Codable {
          var rankinglist: [DMRankingList]?
      }
      
      struct DMRankingList: Codable {
          var title: String
          var subTitle: String
          var cover: String
          var argName: String
          var argValue: StrInt
          var rankingType: String
      }
}
