//
//  GreetingViewModel.swift
//  Swift5Demo
//
//  Created by 阿永 on 2022/8/23.
//  Copyright © 2022 com.ayong.myapp. All rights reserved.
//

import Foundation


protocol GreetingViewModelProtocol: AnyObject {
    var greeting: String? { get }
    var greetingDidChange: ((GreetingViewModelProtocol) -> ())? { get set }
    init(person: Person1)
    func showGreeting()
}

class GreetingViewModel : GreetingViewModelProtocol {
    
    let person: Person1
    
    var greeting: String? {
        didSet {
            self.greetingDidChange?(self)
        }
    }
    
    var greetingDidChange: ((GreetingViewModelProtocol) -> ())?
    
    required init(person: Person1) {
        self.person = person
    }
    
    func showGreeting() {
        self.greeting = "Hello " + self.person.firstName + " " + self.person.lastName
    }
}
