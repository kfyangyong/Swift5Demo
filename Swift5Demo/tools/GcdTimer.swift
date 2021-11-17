//
//  GcdTimer.swift
//  Swift5Demo
//
//  Created by 杨永 on 2021/10/14.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import Foundation


class GcdTimer {
    var timeHandle:(()->())?
        
    private var timer: DispatchSourceTimer?
    private var isSusspended: Bool = false
    
    init(timeInterval: Int) {
        timer = DispatchSource.makeTimerSource(flags: .strict, queue: DispatchQueue.global())
        timer?.schedule(deadline: .now(), repeating: .seconds(timeInterval))
        
        timer?.setEventHandler { [weak self] in
            self?.timerAction()
        }
    }
    
    func startTimer() {
        if isSusspended {
            timer?.resume()
        }
        isSusspended = false
    }
    
    func stopTimer() {
        if isSusspended {
            return
        }
        timer?.suspend()
        isSusspended = true
    }
    
    func releaseTimer() {
        if isSusspended {
            timer?.resume()
        }
        timer?.cancel()
    }
    
    func timerAction() {
        timeHandle?()
    }
    
    deinit {
        releaseTimer()
    }
    
}
