//
//  People.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/1/6.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import Foundation

// 多元素比较排序
typealias SortDescriptor<Root> = (Root, Root) -> Bool

let sortByYear: SortDescriptor<Person> = { $0.yearOfBirth < $1.yearOfBirth }

let sortByLastName: SortDescriptor<Person> = {
    $0.last.localizedStandardCompare($1.last) == .orderedAscending
}

let sortByFirstName: SortDescriptor<Person> = {
    $0.first.localizedStandardCompare($1.first) == .orderedAscending
}

func combine<Root> (sortDescriptors: [SortDescriptor<Root>]) -> SortDescriptor<Root> {
    return { lhs, rhs in
        for areInIncreasingOrder in sortDescriptors {
            if areInIncreasingOrder(lhs, rhs) { return true }
            if areInIncreasingOrder(rhs, lhs) { return false }
        }
        return false
    }
}

//MARK: - “ Comparable 的类型定义一个重载版本”
func sortDescriptor<Root, Value>(key: @escaping (Root) -> Value) -> SortDescriptor<Root> where Value: Comparable
{
    return { key($0) < key($1) }
}

let sortByYearAlt2: SortDescriptor<Person> = sortDescriptor(key: { $0.yearOfBirth })

func sortDescriptor<Root, Value>(
    key: @escaping (Root) -> Value,
    ascending: Bool = true,
    by comparator: @escaping (Value) -> (Value) -> ComparisonResult)
-> SortDescriptor<Root> {
    
    return { lhs, rhs in
        let order: ComparisonResult = ascending
            ? .orderedAscending
            : .orderedDescending
        return comparator(key(lhs))(key(rhs)) == order
    }
}

let sortByFirstName2: SortDescriptor<Person> = sortDescriptor(key: { $0.first }, by: String.localizedStandardCompare)


@objcMembers
final class Person: NSObject {
    @objc dynamic var name: String = ""
    let first: String
    let last: String
    let yearOfBirth: Int
    init(first: String, last: String, yearOfBirth: Int) {
        self.first = first
        self.last = last
        self.yearOfBirth = yearOfBirth
        // super.init() 在这里被隐式调用
    }
}


class TextField: NSObject {
    @objc dynamic var text: String = ""
}


