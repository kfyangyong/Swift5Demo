//
//  NSObjectProtocol.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/1/7.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import Foundation

extension NSObjectProtocol where Self: NSObject {
    func bind<A, Other>(_ keyPath: ReferenceWritableKeyPath<Self,A>,
                        to other: Other,
                        _ otherKeyPath: ReferenceWritableKeyPath<Other,A>)
    -> (NSKeyValueObservation, NSKeyValueObservation)
    where A: Equatable, Other: NSObject
    {
        let one = observe(keyPath, writeTo: other, otherKeyPath)
        let two = other.observe(otherKeyPath, writeTo: self, keyPath)
        return (one,two)
    }
}

extension NSObjectProtocol where Self: NSObject {
    func observe<A, Other>(_ keyPath: KeyPath<Self, A>,
                           writeTo other: Other,
                           _ otherKeyPath: ReferenceWritableKeyPath<Other, A>)
    -> NSKeyValueObservation
    where A: Equatable, Other: NSObjectProtocol
    {
        return observe(keyPath, options: .new) { _, change in
            guard let newValue = change.newValue,
                  other[keyPath: otherKeyPath] != newValue else {
                return // prevent endless feedback loop
            }
            other[keyPath: otherKeyPath] = newValue
        }
    }
}
