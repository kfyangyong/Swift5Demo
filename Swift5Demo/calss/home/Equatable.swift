//
//  Equatable.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/1/8.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import Foundation

struct Eq<A> {
let eq: (A, A) -> Bool
}

protocol Equatable {
    
    
}


extension Array {
func allEqual(_ compare: (Element, Element) -> Bool) -> Bool {
guard let f = first else { return true }
for el in dropFirst() {
guard compare(f, el) else { return false }
}
return true
}
}

