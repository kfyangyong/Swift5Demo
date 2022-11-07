//
//  appDelegateDoc.swift
//  Swift5Demo
//
//  Created by 阿永 on 2022/11/7.
//  Copyright © 2022 com.ayong.myapp. All rights reserved.
//

import Foundation

//MARK: - 如何捕获异常？
/*
 1、在app启动时(didFinishLaunchingWithOptions)，添加一个异常捕获的监听
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
     return YES;
 }
 2、实现捕获异常日志并保存到本地的方法。
 void UncaughtExceptionHandler(NSException *exception){
     // 异常日志获取
     NSArray  *excpArr = [exception callStackSymbols];
     NSString *reason = [exception reason];
     NSString *name = [exception name];
     
     NSString *excpCnt = [NSString stringWithFormat:@"exceptionType: %@ \n reason: %@ \n stackSymbols: %@",name,reason,excpArr];
     
     // 日常日志保存（可以将此功能单独提炼到一个方法中）
     NSArray  *dirArr  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString *dirPath = dirArr[0];
     NSString *logDir = [dirPath stringByAppendingString:@"/CrashLog"];
     
     BOOL isExistLogDir = YES;
     NSFileManager *fileManager = [NSFileManager defaultManager];
     if (![fileManager fileExistsAtPath:logDir]) {
         isExistLogDir = [fileManager createDirectoryAtPath:logDir withIntermediateDirectories:YES attributes:nil error:nil];
     }
     if (isExistLogDir) {
         // 此处可扩展
         NSString *logPath = [logDir stringByAppendingString:@"/crashLog.txt"];
         [excpCnt writeToFile:logPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
     }
 }
 */

//MARK: - 你认为开发中那些导致crash?
/*
 crash产生来源于两种问题：违反iOS系统规则导致的crash和App代码逻辑BUG导致的crash
 1.应用逻辑的Bug
 SEGV：（Segmentation Violation，段违例），无效内存地址，比如空指针，未初始化指针，栈溢出等；
 SIGABRT：收到Abort信号，可能自身调用abort()或者收到外部发送过来的信号；
 SIGBUS：总线错误。与SIGSEGV不同的是，SIGSEGV访问的是无效地址（比如虚存映射不到物理内存），而SIGBUS访问的是有效地址，但总线访问异常（比如地址对齐问题）；
 SIGILL：尝试执行非法的指令，可能不被识别或者没有权限；
 SIGFPE：Floating Point Error，数学计算相关问题（可能不限于浮点计算），比如除零操作；
 SIGPIPE：管道另一端没有进程接手数据； 常见的崩溃原因基本都是代码逻辑问题或资源问题，比如数组越界，访问野指针或者资源不存在，或资源大小写错误等

 2.违反iOS系统规则产生crash的三种类型
 内存报警闪退
 当iOS检测到内存过低时，它的VM系统会发出低内存警告通知，尝试回收一些内存；如果情况没有得到足够的改善，iOS会终止后台应用以回收更多内存；最后，如果内存还是不足，那么正在运行的应用可能会被终止掉。在Debug模式下，可以主动将客户端执行的动作逻辑写入一个log文件中，这样程序童鞋可以将内存预警的逻辑写入该log文件，当发生如下截图中的内存报警时，就是提醒当前客户端性能内存吃紧，可以通过Instruments工具中的Allocations 和 Leaks模块库来发现内存分配问题和内存泄漏问题。
 
 响应超时
 当应用程序对一些特定的事件（比如启动、挂起、恢复、结束）响应不及时，苹果的Watchdog机制会把应用程序干掉，并生成一份相应的crash日志。
 
 用户强制退出
 一看到“用户强制退出”，首先可能想到的双击Home键，然后关闭应用程序。不过这种场景一般是不会产生crash日志的，因为双击Home键后，所有的应用程序都处于后台状态，而iOS随时都有可能关闭后台进程，当应用阻塞界面并停止响应时这种场景才会产生crash日志。这里指的“用户强制退出”场景，是稍微比较复杂点的操作：先按住电源键，直到出现“滑动关机”的界面时，再按住Home键，这时候当前应用程序会被终止掉，并且产生一份相应事件的crash日志
 */
