//
//  YYPlayViewController.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/1/26.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit
import AVFoundation

class YYPlayViewController: BaseViewController {

    var url: String = ""
    let playView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let videoDevices = AVCaptureDevice.default(for: .video) else {
            return
        }
        // 后置摄像头
        let backCamera =  AVCaptureDevice(uniqueID: "com.apple.avfoundation.avcapturedevice.built-in_video:0")!
        // 前置摄像头
        let frontCamera = AVCaptureDevice(uniqueID: "com.apple.avfoundation.avcapturedevice.built-in_video:1")
        // 麦克风
        let microphone = AVCaptureDevice(uniqueID: "com.apple.avfoundation.avcapturedevice.built-in_audio:0")
        print(videoDevices)

        let input = try? AVCaptureDeviceInput(device: backCamera)
        
        let rateRange = backCamera.activeFormat.videoSupportedFrameRateRanges

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
