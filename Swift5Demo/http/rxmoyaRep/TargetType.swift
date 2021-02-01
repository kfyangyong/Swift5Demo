//
//  TargetType.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/1/29.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Alamofire

//public typealias AlManager = Alamofire.Session
//
//enum ResDataType {
//    case decode
//    case utf8
//    case normal
//    
//    func handleData(_ data: Data) -> Data? {
//        switch self {
//        case .decode:
//            let str = String(data: data, encoding: .utf8)
//            let dataStr = str?.safeUrlUnDecode()
//            return dataStr?.data(using: .utf8)
//        case .utf8:
//            let str = String(data: data, encoding: .utf8)
//            let dataStr = str?.safeUrlUnDecodeUtf8()
//            return dataStr?.data(using: .utf8)
//        case .normal:
//            return data
//        }
//    }
//    
//    func mapModel<T: Codable>(_ type: T.Type, data: Data, response: Response) throws -> T  {
//        do {
//            return try JSONDecoder().decode(type, from: handleData(data) ?? Data())
//        } catch {
//            throw MoyaError.jsonMapping(response)
//        }
//    }
//}

//extension TargetType {
//    @discardableResult
////    func fetch(onSuccess: @escaping (_ response: Response) -> (),
////               onError: @escaping (_ error: NetworkError) -> ()) -> Disposable? {
////        //判断网络状态
////        guard Reachability.instance.currentReachabilityStatus != .notReachable else {
////            let error = NetworkError.noNetwork
////            onError(error)
////            return nil
////        }
////
////        let provider = MoyaProvider<Self>.init(requestClosure: MoyaProvider<Self>.requestMapping, plugins: [TokenPlugin()])
////        return provider.rx.request(self).subscribe(
////            onSuccess: { response in
////                if response.statusCode == 200 {
////                    onSuccess(response)
////                } else if response.statusCode == 100 {
////                    DispatchQueue.main.async {
////                        //如果已经弹出更新框，就不再执行登出
////                        onError(NetworkError.loginInvalide)
////                    }
////                }else {
////                    onError(self.handleError(response.statusCode))
////                }
////            },
////            onError: { error in
////                // 连接服务失败
////                if let error = error as? MoyaError {
////                    switch error {
////                    case .underlying(let error, _):
////                        if (error as NSError).code == -1001 {
////                            let netError = NetworkError.timeout
////                            onError(netError)
////                            return
////                        }
////                    default:
////                        break
////                    }
////                    let netError = NetworkError.visitFail((error as NSError).code)
////                    onError(netError)
////                }
////            })
////    }
//}
