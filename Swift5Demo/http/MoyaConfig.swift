//
//  MoyaConfig.swift
//  Swift5Demo
//
//  Created by 杨永 on 2019/9/25.
//  Copyright © 2019 com.ayong.myapp. All rights reserved.
//

import Foundation
import Moya

///1.状态值
enum HttpCode : Int {
    case success = 1 //请求成功的状态吗
    case needLogin = -1  // 返回需要登录的错误码
}

/**
 2.为了统一处理错误码和错误信息，在请求回调里会用这个model尝试解析返回值
 **/
struct BaseModel: Decodable {
    var code: Int
    var data: Content
    struct Content: Decodable {
        var message: String
    }
}

//下面的错误码及错误信息用来在HttpRequest中使用
extension BaseModel {
    var generalCode: Int {
        return code
    }

    var generalMessage: String {
        return data.message
    }
}

/**
 3.配置TargetType协议可以一次性处理的参数d
 **/

public extension TargetType {
    var baseURL: URL {
        return URL.init(string: "https://api.myservice.com")!
    }
           
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    var headers: [String : String]? {
        return ["Content-type":"application/json"]
    }
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}

/**
 4.公共参数
 - Todo: 配置公共参数，例如所有接口都需要传token，version，time等，就可以在这里统一处理
 - Note: 接口传参时可以覆盖公共参数。下面的代码只需要更改 【private var commonParams: [String: Any]?】
 **/
extension URLRequest {
    //TODO：处理公共参数
    private var commonParams: [String: Any]? {
        //所有接口的公共参数添加在这里例如：
        let User_UIID = UIDevice.current.identifierForVendor?.uuidString
        return ["appver": "1.0",
                "apiver": "1.0.0",
                "platform":"ios",
                "imei":User_UIID as Any
        ]
    }
}

//下面的代码不更改
class RequestHandlingPlugin: PluginType {
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var mutateableRequest = request
        return mutateableRequest.appendCommonParams();
    }
}

//下面的代码不更改
extension URLRequest {
    mutating func appendCommonParams() -> URLRequest {
        let request = try? encoded(parameters: commonParams, parameterEncoding: URLEncoding(destination: .queryString))
        assert(request != nil, "append common params failed, please check common params value")
        return request!
    }

    func encoded(parameters: [String: Any]?, parameterEncoding: ParameterEncoding) throws -> URLRequest {
        do {
            return try parameterEncoding.encode(self, with: parameters)
        } catch {
            throw MoyaError.parameterEncoding(error)
        }
    }
}
