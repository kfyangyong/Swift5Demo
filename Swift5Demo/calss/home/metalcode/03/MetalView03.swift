//
//  MetalView03.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/3/11.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import MetalKit

class MetalView03: MTKView {

    var commandQueue: MTLCommandQueue?
    var rps: MTLRenderPipelineState?
    var vertesData: [Float]?
    var vertexBuffer: MTLBuffer?
  
    required init(coder: NSCoder) {
        super.init(coder: coder)
        render()
    }
    
    func render() {
        device = MTLCreateSystemDefaultDevice()
        commandQueue = device?.makeCommandQueue()
        vertesData = [-1.0, -1.0, 0.0, 1.0,
                      1.0, -1.0, 0.0, 1.0,
                      0.0,  1.0, 0.0, 1.0]
        let dataSize = vertesData!.count * MemoryLayout<Float>.size
        vertexBuffer = device?.makeBuffer(bytes: vertesData!, length: dataSize, options: [])
        let library = device?.makeDefaultLibrary()
        let vertes_func = library?.makeFunction(name: "vertes_func")
        let frag_func = library?.makeFunction(name: "fragment_func")
        let rpld = MTLRenderPipelineDescriptor()
        rpld.vertexFunction = vertes_func
        rpld.fragmentFunction = frag_func
        rpld.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        do {
            try rps = device?.makeRenderPipelineState(descriptor: rpld)
        } catch let error {

        }
    }
    
    override func draw(_ rect: CGRect) {
        if let drawable = currentDrawable, let rpd = currentRenderPassDescriptor {
            rpd.colorAttachments[0].clearColor = MTLClearColorMake(0, 0.5, 0.5, 1.0)
            let commandBuffer = commandQueue?.makeCommandBuffer()
            let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: rpd)
            commandEncoder?.setRenderPipelineState(rps as! MTLRenderPipelineState)
            commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
            commandEncoder?.endEncoding()
            commandBuffer?.present(drawable)
            commandBuffer?.commit()
        }
    }


}
