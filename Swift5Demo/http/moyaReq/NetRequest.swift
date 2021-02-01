//
//  NetRequest.swift
//  Swift5Demo
//
//  Created by 杨永 on 2019/9/25.
//  Copyright © 2019 com.ayong.myapp. All rights reserved.
//

import Foundation
import Moya

public class NetRequest {
    
 /// 使用moya的请求封装
 ///
 /// - Parameters:
 ///   - target: TargetType里的枚举值
 ///   -needCache: 是否缓存
 ///   -cache: 需要单独处理缓存的数据时使用，（默认为空，使用success处理缓存数据）
 ///   - success: 成功的回调
 ///   - error: 连接服务器成功但是数据获取失败
 ///   - failure: 连接服务器失败

    public class func loadData <T: TargetType>(target: T,
                                               needCache: Bool = false,
                                               cache: ((Data) -> Void)? = nil,
                                               success: @escaping((Data) -> Void),
                                               failure: ((Int?, String) ->Void)? ) {
        
        let provider = MoyaProvider<T>(plugins: [RequestHandlingPlugin(),networkLoggerPlugin])
        
        //如果需要读取缓存，则优先读取缓存内容
        if needCache, let data = SaveFiles.read(path: target.path) {
            //cache不为nil则使用cache处理缓存，否则使用success处理
            if let block = cache {
                block(data)
            }else {
                success(data)
            }
        }else {
            //读取缓存速度较快，无需显示hud；仅从网络加载数据时，显示hud。
            
            
        //    ProgressHUD.show()
        }

        provider.request(target) { result in
            switch result{
            case let .success(response):
                
                guard let model = try? JSONDecoder().decode(BaseModel.self, from: response.data) else {
                    if response.statusCode == 200 {
                        success(response.data)
                    }else {
                        failure?(response.statusCode,"\(response.statusCode)")
                    }
                    return
                }
                
                //状态码：后台会规定数据正确的状态码，未登录的状态码等，可以统一处理。
                switch (model.generalCode) {
                case HttpCode.success.rawValue :
                    //数据返回正确
                    if needCache {
                        //缓存
                        SaveFiles.save(path: target.path, data: response.data)
                    }
                    success(response.data)
                case HttpCode.needLogin.rawValue:
                    //请重新登录
                    failure?(model.generalCode ,model.generalMessage)
                    alertLogin(model.generalMessage)
                default:
                    //其他错误
                    failureHandle(failure: failure, stateCode: model.generalCode, message: model.generalMessage)
                }

            case let .failure(error):
                let statusCode = error.response?.statusCode ?? 0
                let errorCode = "请求出错，错误码：" + String(statusCode)
                failureHandle(failure: failure, stateCode: statusCode, message: error.errorDescription ?? errorCode)

            }
        }
        
        func failureHandle(failure:((Int?, String) ->Void)? , stateCode:Int?, message:String) {

        }
        
        func alertLogin(_ title: String) {
            
        }
    }
    
    static let networkLoggerPlugin = NetworkLoggerPlugin(verbose: true, cURL: true, output: nil, requestDataFormatter: { (data) -> (String) in
        return String(data:data,encoding: .utf8) ?? ""
    }) { (data) -> (Data) in
        do {
            let dataJson = try JSONSerialization.jsonObject(with: data)
            let prettyData = try JSONSerialization.data(withJSONObject: dataJson, options: JSONSerialization.WritingOptions.prettyPrinted)
            return prettyData
        }catch {
            return data
        }
    }
    
    
}
