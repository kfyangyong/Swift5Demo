//
//  ResultModel.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/1/29.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import Foundation


struct ResultModel<T: Codable>: Codable {
    
    var code: Int?
    var message: String?
    var data: T?
        
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
        case data = "data"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(code, forKey: .code)
        try? container.encode(message, forKey: .message)
        try? container.encode(data, forKey: .data)
    }
    
}
