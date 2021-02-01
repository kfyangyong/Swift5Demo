//
//  UserTargetType.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/1/30.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import Foundation
import Moya


enum UserTargetType {
    case login(para: [String: Any])
    case register(para: [String: Any])
    case getSMS(para: [String: Any])
    case updatePassWord(para: [String: Any])
    case findPassWord(para: [String: Any])
    case getUserInfo
    case updateUsersNickName(para: [String: Any])
    case updateUsersImage(para: [String: Any])
    case uploadUserPortrait(Data, para: [String: Any])
    case getDownloadLine
    case checkUserId
    case deleteUserId(para: [String: Any])
    // 用户协议
    case userProtocol
    case checkVip
}

extension UserTargetType: TargetType {
    
    var path: String {
        var path: String = ""
        switch self {
        case .login:
            path = "product/GongKaoClass/login"
        case .register:
            path = "product/Common/Register"
        case .getSMS:
            path = "product/Common/GetSMS"
        case .updatePassWord:
            path = "product/GongKaoClass/UpdateUserPwd"
        case .findPassWord:
            path = "product/Common/FindPassWord"
        case .getUserInfo:
            path = "product/GongKaoClass/GetUserInfo"
        case .updateUsersNickName:
            path = "product/GongKaoClass/UpdateUsersNickName"
        case .updateUsersImage, .uploadUserPortrait:
            path = "product/GongKaoClass/UpdateUsersImage"
        // GongKaoClass/UpdateUsersImage"
        case .getDownloadLine:
            path = "Common.APP.XiaZaiXianLuQieHuan"
        case .checkUserId:
            path = "product/GongKaoClass/CheckUserId"
        case .deleteUserId:
            path = "product/GongKaoClass/DeleteUserId"
        case .userProtocol:
            path = "product/common/GetUsersXieYi"
        case .checkVip:
            path = "product/GongKaoClass/isVip"
        }
        return path
    }
    
    var method: Moya.Method {
        switch self {
        case .login,
             .register,
             .getSMS,
             .updatePassWord,
             .findPassWord,
             .getUserInfo,
             .updateUsersNickName,
             .updateUsersImage,
             .uploadUserPortrait,
             .checkUserId,
             .deleteUserId,
             .userProtocol,
             .checkVip:
            return .post
            
        case .getDownloadLine:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getUserInfo,
             .checkUserId,
             .getDownloadLine,
             .checkVip,
             .userProtocol:
            return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
        case .login(let para),
             .register(para: let para),
             .getSMS(para: let para),
             .updatePassWord(para: let para),
             .findPassWord(para: let para),
             .updateUsersNickName(para: let para),
             .updateUsersImage(para: let para),
             .uploadUserPortrait(_, para: let para),
             .deleteUserId(para: let para):
            return .requestParameters(parameters: para, encoding: URLEncoding.queryString)
        }
    }
    
    
}
