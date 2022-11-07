//
//  notifyDoc.swift
//  Swift5Demo
//
//  Created by 阿永 on 2022/11/7.
//  Copyright © 2022 com.ayong.myapp. All rights reserved.
//

import Foundation

//MARK: - 通知中心的实现原理？
/*
 推送通知的过程可以分为以下几步：

 1.应用服务提供商从服务器端把要发送的消息和设备令牌（device token）发送给苹果的消息推送服务器APNs。
 2.APNs根据设备令牌在已注册的设备（iPhone、iPad、iTouch、mac等）查找对应的设备，将消息发送给相应的设备。
 3.客户端设备接将接收到的消息传递给相应的应用程序，应用程序根据用户设置弹出通知消息。
 */

//MARK: - 如何进行网络消息推送
/*
 一种是Apple自己提供的通知服务（APNS服务器）、一种是用第三方推送机制。
 推送信息内容，总容量不超过256个字节；
 
 apns
 首先应用发送通知，系统弹出提示框询问用户是否允许.
 当用户允许后向苹果服务器(APNS)请求deviceToken，并由苹果服务器发送给自己的应用，
 自己的应用将DeviceToken发送自己的服务器，
 自己服务器想要发送网络推送时将deviceToken以及想要推送的信息发送给苹果服务器，苹果服务器将信息发送给应用。
 优点：不论应用是否开启，都会发送到手机端；
 缺点：消息推送机制是苹果服务端控制，个别时候可能会有延迟，因为苹果服务器也有队列来处理所有的消息请求；
 
 第三方推送机制
 普遍使用Socket机制来实现，几乎可以达到即时的发送到目标用户手机端，适用于即时通讯类应用。
 优点：实时的，取决于心跳包的节奏；
 缺点：iOS系统的限制，应用不能长时间的后台运行，所以应用关闭的情况下这种推送机制不可用
 */
