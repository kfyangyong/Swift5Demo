//
//  CSAudioEncoder.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/3/22.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class CSAudioEncoder: NSObject {

    typealias AudioEncodeBlock = (_ aacData: Data) -> Void
    
    var encodeBlock: AudioEncodeBlock?
    var config: CSAudioConfig?
    
    private var audioConverter: AudioConverterRef?
    
    private var pcmBuffer: String?
    private var pcmBufferSize: size_t?
    
    init(_ audioConfig: CSAudioConfig) {
        super.init()
        config = audioConfig
    }
    
    func encodeAudioSamepleBuffe(sampleBuffer: CMSampleBuffer) {
        
    }
    
    private lazy var encoderQueue: DispatchQueue = {
        let queue = DispatchQueue(label: "com.CSAudioEncoder.encoderQueue")
        return queue
    }()
    private lazy var callbackQueue: DispatchQueue = {
        let queue = DispatchQueue(label: "com.CSAudioEncoder.callbackQueue")
        return queue
    }()
}
