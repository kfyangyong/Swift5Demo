//
//  ReadMemory.swift
//  Swift5Demo
//
//  Created by 阿永 on 2022/8/23.
//  Copyright © 2022 com.ayong.myapp. All rights reserved.
//

import Foundation

//MARK: - 内存

//结构
/*
 内存地址由低到高
 
 代码段：存放App代码，App程序会拷贝到这里。
 数据段：常量字符串就是放在这里的，还有const常量，全局变量，静态变量，字符串常量
 栈：由系统去管理。地址从高到低分配。先进后出。
    会存一些局部变量，函数跳转跳转时现场保护(寄存器值保存于恢复)，
    这些系统都会帮我们自动实现，无需我们干预。
    所以大量的局部变量，深递归，函数循环调用都可能耗尽栈内存而造成程序崩溃 。
 堆：需要我们自己管理内存，alloc申请内存release释放内存。
    创建的对象也都放在这里。 地址是从低到高分配。
    堆是所有程序共享的内存，当N个这样的内存得不到释放，堆区会被挤爆，程序立马瘫痪。这就是内存泄漏。

 内核：
 
 */

/// Tagged Pointer
/*
 从64bit开始，iOS引入了Tagged Pointer技术，用于优化NSNumber、NSDate、NSString等小对象的存储
 在没有使用Tagged Pointer之前， NSNumber等对象需要动态分配内存、维护引用计数等，NSNumber指针存储的是堆中NSNumber对象的地址值
 使用Tagged Pointer之后，NSNumber指针里面存储的数据变成了：Tag + Data，也就是将数据直接存储在了指针中
 当指针不够存储数据时，才会使用动态分配内存的方式来存储数据
 objc_msgSend能识别Tagged Pointer，比如NSNumber的intValue方法，直接从指针提取数据，节省了以前的调用开销
 
 如何判断一个指针是否为Tagged Pointer？
 iOS平台，最高有效位是1（第64bit）；Mac平台，最低有效位是1
 */

//MARK: - 深浅拷贝
/*
 深拷贝： 新建内存空间
 浅拷贝： 复制指针地址
 
 copy: 对于可变对象为深拷贝，对于不可变对象是浅拷贝
 mutableCopy: 始终是深拷贝
 容器类可变对象mutableCopy和copy都反悔一个新的容器，但容器内的元素仍然是浅拷贝
 
 开发中NSString属性用copy修饰符修饰。
 之所以用copy来修饰NSString属性，是因为可以避免赋值来源是NSMutableString的时候，
 改变可变字符串的值不会影响不可变字符串的值。
 之所以不会影响其原有值，是因为用copy修饰不可变字符串，
 在赋值的时候，在setter方法中会对赋值来源执行一次copy操作，
 当对可变类型执行copy操作，返回新的不可变对象，
 即使改变了来源数据，也不会影响copy修饰的不可变属性！
 所以用copy修饰NSString属性，也可以保证数据安全，不受污染！
 
 完全拷贝的概念是相对于深拷贝来说的。
 在深拷贝的理解中有一种说法是至少是一层深拷贝，
 比如，我们对容器类型的对象执行一次mutableCopy操作时，就进行了深拷贝，
 但这次深拷贝是单层深拷贝，也就是说容器内存地址发生了变化，但容器元素的内存地址没有发生变化，
 我们称它为单层深拷贝，并不是理论上的完全生拷贝！
 （容器类型的内容拷贝，仅限于对象本身，对象元素仍然是指针拷贝）

 我们可以使用归档/解当的方法来实现自定义对象的深拷贝。
 自定义类包括嵌套的类都要实现NSCoding协议，并实现encodeWithCoder/initWithCoder协议方法，
 
 */

//MARK: - 内存管理
/*
 引用计算
 一个新创建的OC对象引用计数默认是1，当引用计数减为0，OC对象就会销毁，释放其占用的内存空间。
 
 //修饰符
 retain会让OC对象的引用计数+1
 release会让OC对象的引用计数-1
 copy 深浅拷贝的问题 NSString、NSDictionary、NSArray要使用copy
                  修饰符声明block属性的时候 copy
 strong 引用计数 +1
 weak 引用计数不变
 
 想象我们的对象是一条狗，狗想要跑掉（被释放）。
 strong型指针就像是栓住的狗。只要你用牵绳挂住狗，狗就不会跑掉。如果有5个人牵着一条狗（5个strong型指针指向1个对象），除非5个牵绳都脱落，否着狗是不会跑掉的。
 weak型指针就像是一个小孩指着狗喊到：“看！一只狗在那”只要狗一直被栓着，小孩就能看到狗，（weak指针）会一直指向它。只要狗的牵绳脱落，狗就会跑掉，不管有多少小孩在看着它。
 只要最后一个strong型指针不再指向对象，那么对象就会被释放，同时所有的weak型指针都将会被清除。
 */

/* AutoreleasePool自动释放池
 是OC中的一种内存自动回收机制，
 在释放池中的调用了autorelease方法的对象都会被压在该池的顶部（以栈的形式管理对象）。
 当自动释放池被销毁的时候，在该池中的对象会自动调用release方法来释放资源，销毁对象。
 以此来达到自动管理内存的目的。

 底层主要结构： _AtAutoreleasePool、AutoreleasePoolPage
 __AtAutoreleasePool 实际是一个结构体，
 在内部首先执行objc_autoreleasePoolPush()，
 然后在调用objc_autoreleasePoolPop(atautoreleasepoolobj)。

 AutoreleasePoolPage的结构
 每个AutoreleasePoolPage对象占用4096字节内存，除了用来存放它内部的成员变量，
 剩下的空间用来存放autorelease对象的地址。
 所有的AutoreleasePoolPage对象通过双向链表的形式连接在一起。

 Runloop和Autorelease的关系
 App启动后，苹果在主线程 RunLoop 里注册了两个 Observer，其回调都是 _wrapRunLoopWithAutoreleasePoolHandler()。
 第一个 Observer 监视的事件是 Entry(即将进入Loop)，
 其回调内会调用 _objc_autoreleasePoolPush() 创建自动释放池。
 其 order 是 -2147483647，优先级最高，保证创建释放池发生在其他所有回调之前。
 
 第二个 Observer 监视了两个事件：
 BeforeWaiting(准备进入休眠) 时调用_objc_autoreleasePoolPop() 和 _objc_autoreleasePoolPush() 释放旧的池并创建新池；
 Exit(即将退出Loop) 时调用 _objc_autoreleasePoolPop() 来释放自动释放池。
 这个 Observer 的 order 是 2147483647，优先级最低，保证其释放池子发生在其他所有回调之后。

 */

//MARK: - 图片的解压缩到渲染过程
/*
 假设我们使用 +imageWithContentsOfFile: 方法从磁盘中加载一张图片，这个时候的图片并没有解压缩；
 然后将生成的 UIImage 赋值给 UIImageView ；
 接着一个隐式的 CATransaction 捕获到了 UIImageView 图层树的变化；
 在主线程的下一个 runloop 到来时，Core Animation 提交了这个隐式的 transaction ，这个过程可能会对图片进行 copy 操作，而受图片是否字节对齐等因素的影响，这个 copy 操作可能会涉及以下部分或全部步骤：
 分配内存缓冲区用于管理文件 IO 和解压缩操作；
 将文件数据从磁盘读到内存中；
 将压缩的图片数据解码成未压缩的位图形式，这是一个非常耗时的 CPU 操作；
 最后 Core Animation 中CALayer使用未压缩的位图数据渲染 UIImageView 的图层。
 CPU计算好图片的Frame,对图片解压之后.就会交给GPU来做图片渲染
 
 渲染流程：
 GPU获取获取图片的坐标
 将坐标交给顶点着色器(顶点计算)
 将图片光栅化(获取图片对应屏幕上的像素点)
 片元着色器计算(计算每个像素点的最终显示的颜色值)
 从帧缓存区中渲染到屏幕上
 
 离屏渲染：指GPU在当前屏幕缓存区以外新开的缓冲区进行渲染操作
 
 触发离屏渲染的方式 ：
 遮罩蒙板、阴影、光栅化
 圆角和maskToBounds一起使用时
 高斯模糊
 设置了组透明度为 YES，并且透明度不为 1 的layer (layer.allowsGroupOpacity/ layer.opacity)

 离屏渲染卡顿原因
 离屏渲染的代价是很高的，主要体现在两个方面：
 1 . 创建新缓冲区
 想进行离屏渲染，首先要创建一个新的缓冲区，消耗内存。

 上下文切换
 离屏渲染的整个过程，需要多次切换上下文环境：
 先从当前屏幕切换到离屏，等到离屏渲染结束后，将离屏缓冲区的渲染结果显示到屏幕上。又需要将上下文环境从离屏切换到当前屏幕。而上下文环境的切换是要付出很大代价的
 既然这么耗性能,为什么有这套机制呢?
 一些特殊效果需要使用额外的 Offscreen Buffer 来保存渲染的中间状态，所以不得不使用离屏渲染。
 特殊产品需求，为实现一些特殊动效果，需要多图层以及离屏缓存区保存中间状态，这种情况下就不得不使用离屏渲染。比如产品需要实现高斯模糊，无论自定义高斯模糊还是调用系统API都会触发离屏渲染。

 一般都是系统自动触发的，比如阴影、圆角、模糊特效等等

 为了复用提高效率而使用离屏渲染一般是主动的行为，是通过 CALayer 的 shouldRasterize 光栅化操作实现的
 虽然离屏渲染会需要多开辟出新的临时缓存区来存储中间状态，但是对于多次出现在屏幕上的数据，可以提前渲染好，从而进行复用，这样CPU/GPU就不用做一些重复的计算。
 */

//MARK: - UI卡顿优化
/*
 CPU
 尽量用轻量级的对象，比如用不到事件处理的地方，可以考虑使用CALayer取代UIView
 不要频繁地调用UIView的相关属性，比如frame、bounds、transform等属性，尽量减少不必要的修改
 尽量提前计算好布局，在有需要时一次性调整对应的属性，不要多次修改属性
 Autolayout会比直接设置frame消耗更多的CPU资源
 图片的size最好刚好跟UIImageView的size保持一致
 控制一下线程的最大并发数量
 尽量把耗时的操作放到子线程：文本处理（尺寸计算、绘制）、图片处理（解码、绘制）等

 
 GPU
 尽量避免短时间内大量图片的显示，尽可能将多张图片合成一张进行显示
 GPU能处理的最大纹理尺寸是4096x4096，一旦超过这个尺寸，就会占用CPU资源进行处理，所以纹理尽量不要超过这个尺寸
 尽量减少视图数量和层次
 减少透明的视图（alpha<1），不透明的就设置opaque为YES
 尽量避免出现 离屏渲染
 
 */
