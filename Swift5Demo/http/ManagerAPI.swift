//
//  ManagerAPI.swift
//  Swift5Demo
//
//  Created by 杨永 on 2019/9/25.
//  Copyright © 2019 com.ayong.myapp. All rights reserved.
//

import Foundation
import Moya


enum ManagerAPI {
    case login(userAccount:String, pwd:String)
    
}

extension ManagerAPI: TargetType {
    
    var path: String {
        switch self {
        case .login( _, _):
            return "/messageAuthCodeLogin"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .login(let userAccount, let pwd):
            return .requestParameters(parameters: ["userAccount": userAccount, "pwd": pwd], encoding: URLEncoding.queryString)
        }
    }

    
}
