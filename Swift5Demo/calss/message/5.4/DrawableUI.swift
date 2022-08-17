//
//  DrawableUI.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/7/17.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit

protocol Drawable {
    func draw() -> String
}

struct Line: Drawable {
    var elements: [Drawable]
    func draw() -> String {
        return elements.map {
            $0.draw()
        }.joined(separator: "")
    }
}

struct Text: Drawable {
    var content: String
    init(_ content: String) {
        self.content = content
    }
    func draw() -> String { return content }
}

struct Space: Drawable {
    func draw() -> String { return " " }
}

struct Stars: Drawable {
    var length: Int
    func draw() -> String {
        return String(repeating: "*", count: length)
    }
}

// 大写
struct AllCaps: Drawable {
    var content: Drawable
    func draw() -> String { return content.draw().uppercased() }
}



@resultBuilder
struct DrawingBuilder {
    static func buildBlock(_ components: Drawable...) -> Drawable {
        return Line(elements: components)
    }
    static func buildEither(first: Drawable) -> Drawable {
        return first
    }
    static func buildEither(second: Drawable) -> Drawable {
        return second
    }
}
