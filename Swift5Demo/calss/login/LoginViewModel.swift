//
//  LoginViewModel.swift
//  Swift5Demo
//
//  Created by 阿永 on 2022/4/15.
//  Copyright © 2022 com.ayong.myapp. All rights reserved.
//

import Foundation
import RxSwift

class LoginViewModel {
    
    let usernameValid: Observable<Bool>
    let passweordValid: Observable<Bool>
    let everythingValid: Observable<Bool>
        
    init(username: Observable<String>, password: Observable<String>) {
        usernameValid = username.map{
            $0.count >= 5
        }.share(replay: 1)
        passweordValid = password.map{
            $0.count >= 5
        }.share(replay: 1)
        everythingValid = Observable.combineLatest(usernameValid, passweordValid){
            $0 && $1
        }.share(replay: 1)
    }
    
}
