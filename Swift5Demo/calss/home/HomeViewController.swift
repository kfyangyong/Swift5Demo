//
//  HomeViewController.swift
//  Swift5Demo
//
//  Created by 杨永 on 2019/9/24.
//  Copyright © 2019 com.ayong.myapp. All rights reserved.
//

import UIKit
import MBProgressHUD

//运算符重载
infix operator !!
func !! <T>(wrapped: T?, failureText: @autoclosure () -> String) -> T {
    if let x = wrapped { return x }
    fatalError(failureText())
}
//

infix operator **
func ** (x: Double, y: Double) -> Double {
    return pow(x, y)
}


struct Point {
    var x: Double
    var y: Double
    private(set) lazy var distanceFromOrigin: Double
        = (x*x + y*y).squareRoot()
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}


class HomeViewController: UIViewController {
    
    let people = [
        Person(first: "Emily", last: "Young", yearOfBirth: 2002),
        Person(first: "David", last: "Gray", yearOfBirth: 1991),
        Person(first: "Robert", last: "Barnes", yearOfBirth: 1985),
        Person(first: "Ava", last: "Barnes", yearOfBirth: 2000),
        Person(first: "Joanne", last: "Miller", yearOfBirth: 1994),
        Person(first: "Ava", last: "Barnes", yearOfBirth: 1998),
    ]
    
    let combined: SortDescriptor<Person> = combine(
        sortDescriptors: [sortByFirstName, sortByLastName,sortByYear]
    )
    
    var point: Point!
    var age: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //新数组顺序改变，people没变
        //        let arr = people.sorted(by: combined)
        //        arr.map { people in
        //            print(people.first + people.last + "\(people.yearOfBirth)")
        //        }
        //        let a = 2 ** 2
        //        print(a)
        //        //lazy
        //        point = Point(x: 3, y: 4)
        //        print(point.distanceFromOrigin)
        //        point.x += 10
        //        print(point.distanceFromOrigin)
        //
        //
        //        var immutablePoint = Point(x: 3, y: 4)
        //        print(immutablePoint.distanceFromOrigin)
        //
        //
        //        let person = Person(first: "Ava", last: "Barnes", yearOfBirth: 1998)
        //        let textField = TextField()
        //        person.bind(\.name, to: textField, \.text)
        //        person.name = "John"
        //        print( textField.text)
        //        textField.text = "Sarah"
        //        print(person.name)
        //
        //
        //        //这是另一种形式的短路求值：第二个条件只有在第一个条件成功后，才会进行判断。
        //        if let first = age, first > 10{
        //            // 执行操作
        //        }
        //        age = 10
        //        if and((age != nil), {age! > 10}) {
        //            print("age")
        //        }
        //
        //        if and1(age != nil, age! > 10) {
        //            print("age1")
        //        }
        //
        //        _ = transform(10, with: nil) // 使用可选值重载
        //        _ = transform1(10) { $0 * $0 } // 使用非可选值重载
        //        _ = transform2(10, with: {
        //            $0 * $0
        //        })
        
        
        split()
        
    }
    
    func and(_ l: Bool, _ r: () -> Bool) -> Bool {
        guard l else { return false }
        return r()
    }
    
    
    //@autoclosure 自动性闭包 标注来告诉编译器它应该将一个特定的参数用闭包表达式包装起来
    func and1(_ l: Bool, _ r: @autoclosure () -> Bool) -> Bool {
        guard l else { return false }
        return r()
    }
    
    //@escaping 逃逸闭包
    //“如果闭包被封装到像是元组或者可选值等类型的话，这个闭包参数也是逃逸的。因为在这种情况下闭包不是直接参数，它将自动变为逃逸闭包
    func transform(_ input: Int, with f: ((Int) -> Int)?) -> Int {
        print("使用可选值重载")
        guard let f = f else { return input }
        return f(input)
    }
    
    func transform1(_ input: Int, with f: (Int) -> Int) -> Int {
        print("使用非可选值重载")
        return f(input)
    }
    
    func transform2(_ input: Int, with f: @escaping (Int) -> Int) -> Int {
        print("使用非可选值重载 transform2")
        return f(input)
    }
    
    //“结构体是值类型，类是引用类型”
    //作为 inout 参数传递的变量必须是用 var 定义的；其次，当把这个变量传递给函数时，必须在变量名前加上 & 符号。”
    
    //& 符号可能会让你想起 C 和 Objective-c 中的取址操作符，或者是 C++ 中的引用传递操作符，但在 Swift 中，其作用是不一样的。就像对待普通的参数一样，Swift 还是会复制传入的 inout 参数，但当函数返回时，会用这些参数的值覆盖原来的值。也就是说，即使在函数中对一个 inout 参数做多次修改，但对调用者来说只会注意到一次修改的发生，也就是在用新的值覆盖原有值的时候。同理，即使函数完全没有对 inout 参数做任何的修改，调用者也还是会注意到一次修改 (willSet 和 didSet 这两个观察者方法都会被调用)
    //“结构体是值类型，所以在结构体之间是不会产生循环引用的 (因为不存在对结构体的引用)。这即是优势又是限制：一方面我们可以少担心一件事，但同时也意味着无法用结构体实现循环数据结构
    
    //要共享一个实例的所有权的话，我们必须使用类。否则，我们可以使用结构体”
    
    //枚举可以有方法，计算属性和下标操作。方法可以被声明为可变或不可变。你可以为枚举实现扩展。 枚举可以实现各种协议
    
    
    func split() {
        //        let s = """
        //                String 有一个特定的 SubSequence 类型，叫做 Substring。Substring 和ArraySlice 很相似：
        //                它是一个以原始字符串内容为基础，用不同起始和结束位置标记的视图。
        //                子字符串和原字符串共享文本存储，这带来的巨大的好处，就是让对字符串切片成为了非常高效的操作
        //                """
        //        let sub = s.split(separator: "。")
        //        print(sub)
        
        
        let text = "👉 Click here for more info."
        let linkTarget =
            URL(string: "https://www.baidu.com")!
        // 尽管使用了 `let`，对象依然是可变的 (引用语义)
        let formatted = NSMutableAttributedString(string: text)
        // 修改文本的部分属性
        if let linkRange = formatted.string.range(of: "Click here") {
            // 将 Swift 范围转换为 NSRange
            // 注意范围的起始值为 3，因为文本前面的颜文字无法在单个 UTF-16 编码单元中被表示
            let nsRange = NSRange(linkRange, in: formatted.string) // {3, 10}
            // 添加属性
            formatted.addAttribute(.link, value: linkTarget, range: nsRange)
        }
        
        
        let lab = UILabel()
        lab.attributedText = formatted
        lab.isUserInteractionEnabled = true
        lab.textColor = .black
        
        lab.frame = CGRect(x: 0, y: 100, width: 300, height: 30)
        view.addSubview(lab)
    }
    
    
}

extension HomeViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        return false
    }
}





