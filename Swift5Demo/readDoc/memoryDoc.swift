//
//  memoryDoc.swift
//  Swift5Demo
//
//  Created by 阿永 on 2022/11/7.
//  Copyright © 2022 com.ayong.myapp. All rights reserved.
//

import Foundation

//MARK: - weak修饰的释放则自动被置为nil的实现原理
/*
 Runtime维护着一个Weak表，用于存储指向某个对象的所有Weak指针
 Weak表是Hash表，Key是所指对象的地址，Value是Weak指针地址的数组
 在对象被回收的时候，经过层层调用，会最终触发下面的方法将所有Weak指针的值设为nil。
 * runtime源码，objc-weak.m 的 arr_clear_deallocating 函数
 weak指针的使用涉及到Hash表的增删改查，有一定的性能开销.
 */


//MARK: - Autorelease的原理 ?
/*
 ARC下面,我们使用@autoreleasepool{}
 来使用一个Autoreleasepool,实际上UIKit 通过RunLoopObserver 在RunLoop二次Sleep间Autoreleasepool进行Pop和Push,
 将这次Loop产生的autorelease对象释放
 对编译器会编译大致如下:
 void *DragonLiContext = objc_ AutoreleasepoolPush();
 // {} 的 code
 objc_ AutoreleasepoolPop(DragonLiContext);
 
 释放时机: 当前RunLoop迭代结束时候释放.
 */

//MARK: - isa指针的作用
/*
 对象的isa指向类，类的isa指向元类（meta class），元类isa指向元类的根类。
 isa帮助一个对象找到它的方法是一个Class 类型的指针.
 每个实例对象有个isa的指针,他指向对象的类，
 而Class里也有个isa的指针, 指向meteClass(元类)。
 元类保存了类方法的列表。当类方法被调用时，先会从本身查找类方法的实现，如果没有，元类会向他父类查找该方法。
 同时注意的是：元类（meteClass）也是类，它也是对象。
 元类也有isa指针,它的isa指针最终指向的是一个根元类(root meteClass).根元类的isa指针指向本身，这样形成了一个封闭的内循环
 */

//MARK: - oc 关键字
/// strong 引用计数 +1
/// weak 指针指向对象，引用计数器不会+1。当weak指针指向的对象被销毁时，weak会被置为nil，所以weak是安全的
/// assign 引用计数不变，只能修饰基本数据类型
/// atomic 原子属性 是线程安全的  spinlock_t(自旋锁:) 会对setter和getter方法进行加锁和解锁的操作
/// nonatomic 非原子属性 是线程不安全的
/// synthesize @synthesize 属性名 = 成员变量名;
/// dynamic 不要帮我生成setter和getter方法
/// copy 视情况而定，分为浅拷贝和深拷贝
/*
 什么时候使用copy关键字？
 1、用于修饰block，
    block内部的代码块是在栈区的、使用copy关键字可以把它放在堆区；
    在ARC中，使用copy和strong效果相同
 2、NSString、NSArray、NSDictionary
    由于父类指针可以指向子类对象（NSString *可以指向NSMutableString对象），
    所以为了保护属性变量不会被修改，所以使用copy修饰
 
 深拷贝与浅拷贝
 
 浅拷贝
 源对象与拷贝对象在内存中是一份
 源对象引用计数+1
 拷贝了一份指向源对象的指针，并未产生新的对象
 
 深拷贝
 源对象与副本对象是两个不同的对象
 源对象引用计数不变，拷贝对象计数器为1
 本质是产生了新的对象
 
 copy与mutableCopy 不论源对象是否可变：
 copy复制出的对象都是不可变的对象
 mutableCopy复制出的对象都是可变对象
 基本类型不允许copy
 
 自定义的类型要实现对应的NSCopying/NSMutableCopying协议：
 -(id)copyWithZone:(NSZone *)zone {
  PersonModel *model = [[[self class] allocWithZone:zone] init];
    model.firstName = self.firstName;
    model.lastName  = self.lastName;
    //未公开的成员--将其拷贝成不可变
    model->_friends = [[NSMutableSet alloc] initWithSet:_friends copyItems:YES];
 }
 - (id)mutableCopyWithZone:(NSZone *)zone{
    PersonModel *model = [[[self class] allocWithZone:zone] init];
    model.firstName = self.firstName;
    model.lastName  = self.lastName;
    //未公开的成员--将其拷贝成可变
    model->_friends = [_friends mutableCopy];
    return model;
 }
 
 集合对象
 对于集合对象，要想实现深拷贝，需要自己手动地对内部元素一一拷贝
 
 */

