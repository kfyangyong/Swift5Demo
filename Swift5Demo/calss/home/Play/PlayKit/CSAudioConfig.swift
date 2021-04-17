//
//  CSAudioConfig.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/3/22.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit

struct CSAudioConfig {
    /**码率*/
    var bitrate = 96000
    ///声道
    var channelCount = 1
    ///采样率
    var sampleRate = 44100
    ///采样点量化
    var sampleSize = 16
}


struct CSVideoConfig {
    
    var fps = 25
    var bitrate = 640*1000
    var width = 480
    var height = 640
}
