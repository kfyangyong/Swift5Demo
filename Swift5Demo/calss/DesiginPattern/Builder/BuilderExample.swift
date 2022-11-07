//
//  BuilderExample.swift
//  Swift5Demo
//
//  Created by 阿永 on 2022/8/24.
//  Copyright © 2022 com.ayong.myapp. All rights reserved.
//

import Foundation

//需要创建一个可能有许多配置选项的对象时
protocol DomainModel {
    //公共属性
    
}

struct User: DomainModel {
    let id: Int
    let age: Int
    let email: String
}


class BaseQueryBuilder<Model: DomainModel> {
    typealias Predicate = (Model) -> (Bool)
    
    func limit(_ limit: Int) -> BaseQueryBuilder {
        return self
    }
    
    func filter(_ predicate: @escaping Predicate) -> BaseQueryBuilder<Model> {
        return self
    }
    func fetch() -> [Model] {
        preconditionFailure("** should be overridden in subclass")
    }
}

class RealmQueryBuilder<Model: DomainModel>: BaseQueryBuilder<Model> {
    enum Query {
        case filter(Predicate)
        case limit(Int)
    }
    
    fileprivate var operations = [Query]()
    
    @discardableResult
    override func limit(_ limit: Int) -> BaseQueryBuilder<Model> {
        operations.append(Query.limit(limit))
        return self
    }
    
    @discardableResult
    override func filter(_ predicate: @escaping BaseQueryBuilder<Model>.Predicate) -> BaseQueryBuilder<Model> {
        operations.append(Query.filter(predicate))
        return self
    }
    
    override func fetch() -> [Model] {
        print("RealmQueryBuilder: Initializing CoreDataProvider with \(operations.count) operations:")
        return RealmProvider().fetch(operations)
    }
}

class CoreDataQueryBuilder<Model: DomainModel>: BaseQueryBuilder<Model> {
    enum Query {
        case filter(Predicate)
        case limit(Int)
        case includesPropertyValues(Bool)
    }
    
    fileprivate var operations = [Query]()
    override func limit(_ limit: Int) -> BaseQueryBuilder<Model> {
        operations.append(Query.limit(limit))
        return self
    }
    
    override func filter(_ predicate: @escaping BaseQueryBuilder<Model>.Predicate) -> BaseQueryBuilder<Model> {
        operations.append(Query.filter(predicate))
        return self
    }
    
    func includesPropertyValues(_ toggle: Bool) -> CoreDataQueryBuilder<Model> {
        operations.append(Query.includesPropertyValues(toggle))
        return self
    }
    
    override func fetch() -> [Model] {
        print("CoreDataQueryBuilder: Initializing CoreDataProvider with \(operations.count) operations.")
        return CoreDataProvider().fetch(operations)
    }
    
}

class RealmProvider {
    func fetch<Model: DomainModel>(_ operations: [RealmQueryBuilder<Model>.Query]) -> [Model] {
        print("RealmProvider: Retrieving data from Realm...")

        for item in operations {
            switch item {
            case .filter(_):
                print("RealmProvider: executing the 'filter' operation.")
                /// Use Realm instance to filter results.
                break
            case .limit(_):
                print("RealmProvider: executing the 'limit' operation.")
                /// Use Realm instance to limit results.
                break
            }
        }

        /// Return results from Realm
        return []
    }
}
class CoreDataProvider {

    func fetch<Model: DomainModel>(_ operations: [CoreDataQueryBuilder<Model>.Query]) -> [Model] {

        /// Create a NSFetchRequest

        print("CoreDataProvider: Retrieving data from CoreData...")

        for item in operations {
            switch item {
            case .filter(_):
                print("CoreDataProvider: executing the 'filter' operation.")
                /// Set a 'predicate' for a NSFetchRequest.
                break
            case .limit(_):
                print("CoreDataProvider: executing the 'limit' operation.")
                /// Set a 'fetchLimit' for a NSFetchRequest.
                break
            case .includesPropertyValues(_):
                print("CoreDataProvider: executing the 'includesPropertyValues' operation.")
                /// Set an 'includesPropertyValues' for a NSFetchRequest.
                break
            }
        }

        /// Execute a NSFetchRequest and return results.
        return []
    }
}
