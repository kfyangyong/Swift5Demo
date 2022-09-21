//
//  GreetingViewEventHandler.swift
//  Swift5Demo
//
//  Created by 阿永 on 2022/8/23.
//  Copyright © 2022 com.ayong.myapp. All rights reserved.
//

import Foundation

protocol GreetingViewEventHandler {
    func didTapShowGreetingButton()
}

protocol GreetingView1: AnyObject {
    func setGreeting(greeting: String)
}

class Greeting2Presenter: GreetingOutput, GreetingViewEventHandler {
    weak var view: GreetingView1!
    var greetingProvider: GreetingProvider!
    
    func didTapShowGreetingButton() {
        self.greetingProvider.provideGreetingData()
    }
    
    func receiveGreetingData(greetingData: GreetingData) {
        let greeting = greetingData.greeting + " " + greetingData.subject
        self.view.setGreeting(greeting: greeting)
    }
}
