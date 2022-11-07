//
//  Image.swift
//  Swift5Demo
//
//  Created by 阿永 on 2022/11/7.
//  Copyright © 2022 com.ayong.myapp. All rights reserved.
//

import UIKit

/*
 添加封皮 方便节点扩展
 */

/// Wrapper for Kingfisher compatible types. This type provides an extension point for
/// convenience methods in Kingfisher.     （Wrapper 封皮）
public struct KingfisherWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

/// Represents an object type that is compatible with Kingfisher. You can use `kf` property to get a
/// value in the namespace of Kingfisher.
public protocol KingfisherCompatible: AnyObject { }

/// Represents a value type that is compatible with Kingfisher. You can use `kf` property to get a
/// value in the namespace of Kingfisher.

extension KingfisherCompatible {
    /// Gets a namespace holder for Kingfisher compatible types.
    public var kf: KingfisherWrapper<Self> {
        get { return KingfisherWrapper(self) }
        set { }
    }
}

public protocol KingfisherCompatibleValue {}

extension KingfisherCompatibleValue {
    /// Gets a namespace holder for Kingfisher compatible types.
    public var kf: KingfisherWrapper<Self> {
        get { return KingfisherWrapper(self) }
        set { }
    }
}

//UIImageView 可以使用 .kf
extension UIImageView: KingfisherCompatible { }
extension UIImage: KingfisherCompatible { }


private var animatedImageDataKey: Void?
private var imageFrameCountKey: Void?
// 关联属性
// MARK: - Image Properties
extension KingfisherWrapper where Base: UIImage {
    private(set) var animatedImageData: Data? {
        get { return getAssociatedObject(base, &animatedImageDataKey) }
        set { setRetainedAssociatedObject(base, &animatedImageDataKey, newValue) }
    }
    
    public var imageFrameCount: Int? {
        get { return getAssociatedObject(base, &imageFrameCountKey) }
        set { setRetainedAssociatedObject(base, &imageFrameCountKey, newValue) }
    }
}


//eg:
class eg1 {
    let img = UIImage().kf.imageFrameCount = 10
}
