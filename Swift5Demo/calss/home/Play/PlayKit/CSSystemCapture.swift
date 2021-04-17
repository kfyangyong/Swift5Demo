//
//  CSSystemCapture.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/3/19.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

enum CSSystemCaptureType {
    case video
    case audio
    case all
}

protocol CSSystemCapturePro: class {
    func capture(buffer: CMSampleBuffer, type: CSSystemCaptureType)
}

extension CSSystemCapturePro {
    func capture(buffer: CMSampleBuffer, type: CSSystemCaptureType) {}
}

class CSSystemCapture: NSObject {

    weak var delegate: CSSystemCapturePro?
    var width = 100
    var height = 100
    
    private var isRuning: Bool = false
    
    private var capture: CSSystemCaptureType = .all

    //MARK: - 音频
    private var audioInputDevice: AVCaptureDeviceInput?
    private var audioDataOutput: AVCaptureAudioDataOutput?
    private var audioConnection: AVCaptureConnection?
    
    //MARK: - 视频
    private var videoInputDevice: AVCaptureDeviceInput?
    private var frontCamera: AVCaptureDeviceInput?
    private var backCamera: AVCaptureDeviceInput?
    private var videoDataOutput: AVCaptureVideoDataOutput?
    private var videoConnection: AVCaptureConnection?
    private var preLayer: AVCaptureVideoPreviewLayer?
    private var prelayerSize: CGSize?
    
    init(_ type: CSSystemCaptureType = .all) {
        super.init()
        self.capture = type
    }
    
    func prepare(size: CGSize = CGSize.zero) {
        prelayerSize = size
        switch capture {
        case .video:
            setupVideo()
        case .audio:
            setupAudio()
        case .all:
            setupVideo()
            setupAudio()
        }
    }
    
    func start() {
        if !isRuning {
            isRuning = true
            captureSession.startRunning()
        }
    }
    func stop() {
        if isRuning {
            isRuning = false
            captureSession.stopRunning()
        }
    }
    func changeCamera() {
        switchCamera()
    }
    
    //MARK: - private
    private func setupAudio() {
        let audioDevice = AVCaptureDevice.default(for: .audio)
        audioInputDevice = try? AVCaptureDeviceInput(device: audioDevice!)
        audioDataOutput = AVCaptureAudioDataOutput()
        audioDataOutput?.setSampleBufferDelegate(self, queue: captureQueue)
        captureSession.beginConfiguration()

        if captureSession.canAddInput(audioInputDevice!) {
            captureSession.addInput(audioInputDevice!)
        }
        if captureSession.canAddOutput(audioDataOutput!) {
            captureSession.addOutput(audioDataOutput!)
        }
        captureSession.commitConfiguration()
        audioConnection = audioDataOutput?.connection(with: .audio)
    }
    
    private func setupVideo() {
        
        // 后置摄像头
        let backCameraDevice =  AVCaptureDevice(uniqueID: "com.apple.avfoundation.avcapturedevice.built-in_video:0")
        // 前置摄像头
        let frontCameraDevice = AVCaptureDevice(uniqueID: "com.apple.avfoundation.avcapturedevice.built-in_video:1")
        // 麦克风
        let microphoneDevice = AVCaptureDevice(uniqueID: "com.apple.avfoundation.avcapturedevice.built-in_audio:0")
              
        do {
            try backCamera = AVCaptureDeviceInput(device: backCameraDevice!)
            try frontCamera = AVCaptureDeviceInput(device: frontCameraDevice!)
        } catch  {
            
        }
          
        videoInputDevice = backCamera
        videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput?.setSampleBufferDelegate(self, queue: captureQueue)
        videoDataOutput?.alwaysDiscardsLateVideoFrames = true
        videoDataOutput?.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String : NSNumber(value: kCVPixelFormatType_420YpCbCr8PlanarFullRange)]
        
        captureSession.beginConfiguration()
        if captureSession.canAddInput(videoInputDevice!) {
            captureSession.addInput(videoInputDevice!)
        }
        if captureSession.canAddOutput(videoDataOutput!) {
            captureSession.addOutput(videoDataOutput!)
        }
        //设置分辨率
        setVideoPreset()
        captureSession.commitConfiguration()
        videoConnection = videoDataOutput?.connection(with: .video)
        //视频输出方向
        videoConnection?.videoOrientation = .portrait
        updateFps(fps: 25)
        setupPreviewLayer()
    }
    
    ///更新fps
    //FPS是图像领域中的定义，是指画面每秒传输帧数，通俗来讲就是指动画或视频的画面数。
    //FPS是测量用于保存、显示动态视频的信息数量。每秒钟帧数愈多，所显示的动作就会越流畅。通常，要避免动作不流畅的最低是30。某些计算机视频格式，每秒只能提供15帧。
    private func updateFps(fps: Int) {
        guard let device = videoInputDevice?.device else { return }
        let rateRange = videoInputDevice?.device.activeFormat.videoSupportedFrameRateRanges.first
        guard let max = rateRange?.maxFrameRate else { return }
        if Int(max) > fps {
            try? device.lockForConfiguration()
            device.activeVideoMinFrameDuration = CMTime(value: 10, timescale: 10)
            device.activeVideoMaxFrameDuration = device.activeVideoMinFrameDuration
            device.unlockForConfiguration()
        }
    }
    
    ///设置预览
    private func setupPreviewLayer() {
        preLayer = AVCaptureVideoPreviewLayer(layer: captureSession)
        preLayer?.frame = CGRect(x: 0, y: 0, width: prelayerSize!.width, height: prelayerSize!.height)
        preView.layer.addSublayer(preLayer!)
    }
    
    //设置分辨率
    private func setVideoPreset() {
        if captureSession.canSetSessionPreset(.hd4K3840x2160) {
            captureSession.sessionPreset = .hd4K3840x2160
        } else if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        } else if captureSession.canSetSessionPreset(.hd1280x720) {
            captureSession.sessionPreset = .hd1280x720
        } else {
            captureSession.sessionPreset = .vga640x480
        }
    }
    
    //切换摄像头
    private func switchCamera() {
        captureSession.beginConfiguration()
        guard let device = videoInputDevice else {
            return
        }
        captureSession.removeInput(device)
        if device == frontCamera  {
            videoInputDevice = backCamera
            captureSession.addInput(backCamera!)
        } else {
            videoInputDevice = frontCamera
            captureSession.addInput(frontCamera!)
        }
        captureSession.commitConfiguration()
    }
    
   
    private lazy var captureSession: AVCaptureSession = {
        let cap = AVCaptureSession()
        return cap
    }()
    
    private lazy var captureQueue: DispatchQueue = {
        let queue = DispatchQueue.main
        return queue
    }()
    
    private lazy var preView: UIView = {
        let view = UIView()
        return view
    }()

    
}

extension CSSystemCapture: AVCaptureAudioDataOutputSampleBufferDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    
}

extension CSSystemCapture {
    static func checkMicrophoneAuthor() {
        
    }
    
    static func checkCameraAuthor() {
        
    }
}
