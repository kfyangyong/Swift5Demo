//
//  MetalView.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/3/11.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit
import MetalKit

class MetalView: MTKView {

    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        device = MTLCreateSystemDefaultDevice()
    }
    
    override func draw() {
        
        if let drawable = currentDrawable, let rpd = currentRenderPassDescriptor {
            rpd.colorAttachments[0].texture = currentDrawable?.texture
            rpd.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 0.5, blue: 0.5, alpha: 1)
            rpd.colorAttachments[0].loadAction = .clear
            
            let commanBuffer = device?.makeCommandQueue()?.makeCommandBuffer()
            let commandEncoder = commanBuffer?.makeRenderCommandEncoder(descriptor: rpd)
            commandEncoder?.endEncoding()
            commanBuffer?.present(drawable)
            commanBuffer?.commit()
        }
    }

}
