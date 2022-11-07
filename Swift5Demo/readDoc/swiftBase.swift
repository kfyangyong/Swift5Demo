//
//  swiftBase.swift
//  MYSwift
//
//  Created by 阿永 on 2022/3/8.
//

import Foundation

//MARK: - swift 与oc 区别
/*
 1、swift是静态语言，有类型推断；oc是动态语言；
 2、swift面向协议编程，oc是面向对象编程
 3、swift注重值类型，oc注重引用类型
 4、swift支持泛型，oc只支持轻量泛型
 5、swift支持函数编程
 6、swift支持静态派发，动态派发，消息派发，oc仅支持消息派发
 7、swift的协议不仅可以被类实现，也可以被结构体，枚举实现
 8、swift有元组类型，支持运算符重载
 9、swift支持命名空间
 10、swift支持默认函数
 11、swift比oc更加简洁
 */

//MARK: - Swift派发
/*
 派发机制：函数表派发，静态派发，消息派发
 
 struct，enum使用直接派发，
 swift中协议的extensions 使用直接派发，
 初始化声明函数使用函数表派发
 class中extension使用直接派发，初始化声明函数是函数表派发，dunamic修饰的函数使用消息派发；
 nsobject的子类用 @nonobjc 或final修饰的函数使用直接派发，初始化声明函数是函数表派发；
 派发方式查看：可将swift代码转sil（中间码）：swiftc -emit-silgen -O example.swift
 
 */
//MARK: - swift显示指定派发方式？
/*
 1.添加final关键字的函数使用直接派发
 2.添加static关键字函数使用直接派发
 3.添加dynamic关键字函数使用消息派发
 4.添加 @objc关键字的函数使用消息派发
 5.添加 @inline关键字的函数告诉编译器可以使用直接派发
 */

//MARK: - Struct和Class区别
/*
 1、struct不支持继承，oc支持
 2、struct是值类型，oc是引用类型
 3、struct无法修改自身属性值，函数需要添加mutating关键字
 4、struct初始化是基于属性的
 5、struct不需要deinit方法，因为值类型不关心引用计数
 */

//MARK: - Swift中的常量和OC中的常量有啥区别？
/*
 OC中的常量（const）是编译期决定的，Swift中的常量（let）是运行时确定的
 */

//MARK: -swift中mutating的作用？
/*
 swift中协议是可以被Struct和enum实现的，mutating关键字是为了能在被修饰的函数中修改struct或enum的变量值。对Class完全透明。
 */
//MARK: - final关键词的用法
/*
 1、它修饰的类、方法、变量是不能被继承或重写；
 2、它可以显示指派函数的派发机制为直接派发。
 */
//MARK: - lazy关键词的用法
/*‘
 指定延时加载，懒加载存储属性只会在首次使用时才会计算初始值属性
 lazy修饰的属性是非线程安全的
 */

//MARK: - swift 中关于open ,public ,internal，fileprivate,private 修饰的说明
/*
 open
 修饰的类可以在模块sdk，或者引入其他模块的继承。如果修饰属性的话可以被此模块或引入此模块的sdk所重写
 public
 比open低一级，只能在本模块内继承，如果是修饰属性的话，只能被改模块的子类重写
 
 internal
 模块内访问，模块外不允许访问
 
 fileprivate
 同一个source文件中允许访问
 
 private 只允许在当前类里访问
 */

//MARK: - Swift 是面向对象还是函数式编程语言
/*
 Swift 既是面向对象的，又是函数式的编程语言。
 说 Swift 是面向对象的语言，是因为 Swift 支持类的封装、继承、和多态.
 说 Swift 是函数式编程语言，是因为 Swift 支持 map, reduce, filter, flatmap 这类去除中间状态、数学函数式的方法，更加强调运算结果而不是中间过程。
 */

//MARK: - Swift的静态派发
/*
 动态派发:指的是方法在运行时才找具体实现.Swift 中的动态派发和 OC 中的动态派发是一样的.
 静态派发:静态派发是指在运行时调用方法不需要查表,直接跳转到方法的代码中执行.
 静态派发的特点:
 静态派发更高效,因为静态派发免去了查表操作.
 静态派发的条件是方法内部的代码必须对编译器透明,且在运行时不能被更改,这样编译器才能帮助我们.
 Swift 中的值类型不能被继承,也就是说值类型的方法实现不能被修改或者被复写,因此值类型的方法满足静态派发.
 */

//MARK: - autoclosure 的作用
//自动闭包，将参数自动封装为闭包参数

//MARK: - swift中,如何阻止方法,属性,下标被子类改写?
/*
 在类的定义中使用 final 关键字声明类、属性、方法和下标。final 声明的类不能被继承，final 声明的属性、方法和下标不能被重写。
 如果只是限制一个方法或属性被重写,只需要在该方法或者属性前加一个 final.
 如果需要限制整个类无法被继承, 那么可以在类名之前加一个final。
 */

//MARK: - Optional(可选型)是什么?Optional(可选型)解决方式
/*
 Optional 是一个泛型枚举
 enum Optional<Wrapped> {
   case none
   case some(Wrapped)
 }
 
 optional 类型表示有值/没有值
 在oc中并没有optional，只有nil，并且nil只能用于表示对象类型无值，并不能用于基础类型，枚举类型和结构体。
 在swift中，optional类型表示各种类型的无值状态，并且规定nil不能用于可选的常量和变量，只能用于optional。
 
 强行打开不安全： let a: String = x!
 隐式解包变量声明 - 在许多情况下不安全 var a = x!
 可选绑定 - 安全
 if let a = x {
 print("x was successfully unwrapped and is = \(a)")
 }
 
 可选链接 - 安全 let a = x?.count
 无合并操作员 - 安全 let a = x ?? ""
 
 警卫声明 - 安全
 guard let a = x else {
   return
 }
 
 可选模式 - 安全
 if case let a? = x {
   print(a)
 }
 */

//MARK: - inout 的作用
/*
 inout 输入输出参数，让输入参数可变类似__block 的作用。
 1 函数参数默认为常量。试图从函数主体内部更改函数参数的值会导致编译时错误。这意味着您不能错误地更改参数的值。如果您希望函数修改参数的值，并且希望这些更改在函数调用结束后仍然存在，请将该参数定义为输入输出参数。
 2 您可以通过将inout关键字放在参数类型的前面来编写输入/输出参数。一个在出参数具有传递的值中，由函数修改的功能，并将该部分送回出的功能来代替原来的值。
 3 您只能将变量作为输入输出参数的参数传递。您不能将常量或文字值作为参数传递，因为无法修改常量和文字。当您将一个与号（&）作为变量传入in-out参数时，将它放在变量名的前面，以表明该变量可以被函数修改。
 4 注意:输入输出参数不能具有默认值，并且可变参数不能标记为inout。
 */


//MARK: - Error 如果要兼容 NSError 需要做什么操作
/*
 Error是一个协议, swift中的Error 都是enum, 可以转 NSError.如果需要Error有NSError的功能,实现 LocalizedError CustomNSError 协议.
 */

//MARK: - 权限修饰符
/*
 open ：修饰的属性或者方法在其他作用域既可以被访问也可以被继承或重载 override。
 public ：修饰的属性或者方法可以在其他作用域被访问，但不能在重载 override 中被访问，也不能在继承方法中的 Extension 中被访问。
 internal：被修饰的属性和方法只能在模块内部可以访问，超出模块内部就不可被访问了。（默认）
 fileprivate ：其修饰的属性或者方法只能在当前的 Swift 源文件里可以访问。
 private ：只允许在当前类中调用，不包括 Extension ，用 private 修饰的方法不可以被代码域之外的地方访问。
 从高到低排序如下：
 open > public > interal > fileprivate > private
 */

//MARK: -  struct 与 class 的区别
/*
 1 struct是值类型，class是引用类型：
 值类型的变量直接包含它们的数据，对于值类型都有它们自己的数据副本，因此对一个变量操作不可能影响另一个变量.值类型包括结构体 (数组和字典)，枚举，基本数据类型 (boolean, integer, float等).
 引用类型的变量存储对他们的数据引用,对一个变量操作可能影响另一个变量.
 二者的本质区别：struct是深拷贝；class是浅拷贝。
 2 property的初始化不同：
 class 在初始化时不能直接把 property 放在默认的 constructor 的参数里，而是需要自己创建一个带参数的 constructor；而struct可以，把属性放在默认的 constructor 的参数里。
 3 变量赋值方式不同：
 struct是值拷贝；class是引用拷贝。
 4 immutable变量：
 swift的可变内容和不可变内容用var和let来甄别，如果初始为let的变量再去修改会发生编译错误。struct遵循这一特性；class不存在这样的问题。
 5 mutating function：
 struct 和 class 的差別是 struct 的 function 要去改变 property 的值的时候要加上 mutating，而 class 不用。
 6 继承：
 struct不可以继承，class可以继承。
 7 struct比class更轻量：
 struct分配在栈中，class分配在堆中。
 */

//MARK: - 举例swift中模式匹配的作用？
/*
 模式匹配： 在switch中体现最明显
 通配符模式： _
 标识符模式：let i = 1
 值绑定模式：case .Student(let name) 或者 case let .Student(name)
 元祖模式：case (let code, _)
 可选模式：if case let x？ = someOptional { }
 类型转换模式：case is Int: 或者 case let n as String:
 表达式模式：范围匹配 case (0..<2) case(0...2, 2...4)
 条件句中使用where： case (let age) where age > 30
 if case let：if case let .Student(name) = xiaoming { }
 for case let： for case let x in array where x > 10 {} 或者 for x in array where x > 10
 
 */

//MARK: -  swift中 closure 与OC中block的区别？
/*
 1、closure是匿名函数、block是一个结构体对象
 2、closure通过逃逸闭包来在内部修改变量，block 通过 __block 修饰符
 */

//MARK: - Swift 中的 KVC 和 KVO
/*
 KVC
 要继承 NSObject

 class KVCClass :NSObject{
     var someValue: String = "123"
 }
 let kvc = KVCClass()
 kvc.someValue // 123
 kvc.setValue("456", forKey: "someValue")
 kvc.someValue // 456
 KVO
 由于 Swift 为了效率, 默认禁用了动态派发, 因此 Swift 要实现 KVO, 除了要继承自 NSObject 外还要将观测的对象标记为 dynamic(让 swift 代码也能有 Objective-C 中的动态机制).

 class KVOClass:NSObject {
     dynamic var someValue: String = "123"
     var someOtherValue: String = "abc"
 }

 class ObserverClass: NSObject {
     func observer() {
         let kvo = KVOClass()
         kvo.addObserver(self, forKeyPath: "someValue", options: .new, context: nil)
         kvo.addObserver(self, forKeyPath: "someOtherValue", options: .new, context: nil)
         kvo.someValue = "456"
         kvo.someOtherValue = "def"
         kvo.removeObserver(self, forKeyPath: "someValue")
         kvo.removeObserver(self, forKeyPath: "someOtherValue")
     }
     override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
         print("\(keyPath!) change to \(change![.newKey] as! String)")
     }
 }
 ObserverClass().observer()
 */

//MARK: - 什么是泛型,swift在哪些地方使用了泛型？
/*
 泛型（generic）可以使我们在程序代码中定义一些可变的部分，在运行的时候指定。
 使用泛型可以最大限度地重用代码、保护类型的安全以及提高性能。
 */

//MARK: - map、filter、reduce 的作用
/*
 map 用于映射, 可以将一个列表转换为另一个列表
 [1, 2, 3].map{"\($0)"}// 数字数组转换为字符串数组
 ["1", "2", "3"]
 
 filter 用于过滤, 可以筛选出想要的元素
 [1, 2, 3].filter{$0 % 2 == 0} // 筛选偶数
 // [2]
 
 reduce 合并
 [1, 2, 3].reduce(""){$0 + "\($1)"}// 转换为字符串并拼接
 // "123"
 */

//MARK: - flatMap与map不同之处：
/*
 1、flatMap返回后的数组中不存在nil，同时它会把Optional解包
 let array = ["Apple", "Orange", "Puple", ""]

 let arr1 = array.map { a -> Int? in
     let length = a.characters.count
     guard length > 0 else { return nil }
     return length
 }
 arr1 // [{some 5}, {some 6}, {some 5}, nil]

 let arr2 = array.flatMap { a-> Int? in
     let length = a.characters.count
     guard length > 0 else { return nil}
     return length
 }
 arr2 // [5, 6, 5]
 
 2、flatMap还能把数组中存有数组的数组（二维数组、N维数组）一同打开变成一个新的数组
 let array = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

 let arr1 = array.map{ $0 }
 arr1 // [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

 let arr2 = array.flatMap{ $0 }
 arr2 // [1, 2, 3, 4, 5, 6, 7, 8, 9]
 
 3、flatMap也能把两个不同的数组合并成一个数组，这个合并的数组元素个数是前面两个数组元素个数的乘积
 let fruits = ["Apple", "Orange", "Puple"]
 let counts = [2, 3, 5]

 let array = counts.flatMap { count in
     fruits.map ({ fruit in
          return fruit + "  \(count)"
     })
 }
 array // ["Apple 2", "Orange 2", "Puple 2", "Apple 3", "Orange 3", "Puple 3", "Apple 5", "Orange 5", "Puple 5"]
 */

//MARK: - defer、guard的作用？
/*
 defer 语句块中的代码, 会在当前作用域结束前调用,无论函数是否会抛出错误。
 每当一个作用域结束就进行该作用域defer执行。
 如果有多个 defer, 那么后加入的先执行.
 
 guard :过滤器，拦截器
 guard 和 if 类似, 不同的是, guard 总是有一个 else 语句, 如果表达式是假或者值绑定失败的时候, 会执行 else 语句, 且在 else 语句中一定要停止函数调用.
 */

//MARK: - throws 和 rethrows 的用法与作用
/*
 throws 用在函数上, 表示这个函数会抛出错误.
 有两种情况会抛出错误, 一种是直接使用 throw 抛出, 另一种是调用其他抛出异常的函数时, 直接使用 try XX 没有处理异常.

 enum DivideError: Error {
     case EqualZeroError;
 }
 func divide(_ a: Double, _ b: Double) throws -> Double {
     guard b != Double(0) else {
         throw DivideError.EqualZeroError
     }
     return a / b
 }
 func split(pieces: Int) throws -> Double {
     return try divide(1, Double(pieces))
 }

 rethrows 与 throws 类似, 不过只适用于参数中有函数, 且函数会抛出异常的情况, rethrows 可以用 throws 替换, 反过来不行
 func processNumber(a: Double, b: Double, function: (Double, Double) throws -> Double) rethrows -> Double {
     return try function(a, b)
 }
 */

//MARK: -  如何自定义下标获取
/*
 实现 subscript 即可, 如

 extension AnyList {
     subscript(index: Int) -> T{
         return self.list[index]
     }
     subscript(indexString: String) -> T?{
         guard let index = Int(indexString) else {
             return nil
         }
         return self.list[index]
     }
 }
 */

//MARK: - weak和unowned
/*
 弱引用（ weak ）和无主引用（ unowned ）
 
 当一个实例的生命周期比较引用它的实例短，也就是这个实例可能会先于引用它的实例释放的时候，需要使用弱引用（ weak ）。对与一栋公寓来说在它的生命周期中是完全可以没有住户的，所以在这种情况下。相反，当一个实例拥有和引用它的实例相同的生命周期或是比引用它的实例更长的生命周期的时候，需要使用无主引用（ unowned ）。

 一、weak与unowned的区别
 unowned设置以后即使它原来引用的内容已经被释放了，
 它仍然会保持对被已经释放了的对象的一个 无效的引用，
 它不能是 Optional 值，也不会被指向 nil 。
 如果你尝试调用这个引用的方法或者访问成员属性的话，程序就会崩溃。
 而 weak 则友好一些，在引用的内容被释放后，标记为 weak 的成员将会自动地变成 nil (因此被标记为 @weak 的变量一定需要是 Optional 值)。

 在闭包里面为了解决循环引问题，使用了 [unowned self]。如果回调在self已经被释放后再调用，会导致crash掉。

 弱引用 weak
 弱引用创建出来的变量是可选的
 弱引用设置为 nil 的时候不会触发属性观察者
 
 无主引用 unowned
 无主引用和弱引用类似，不会 retain 当前实例对象的引用，非可选，当一个对象被 unowned 标识之后，假定永远有值，非可选类型
 非可选类型，访问时有 crash 风险
 */




