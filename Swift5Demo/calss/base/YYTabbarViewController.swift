//
//  YYTabbarViewController.swift
//  Swift5Demo
//
//  Created by 杨永 on 2019/9/24.
//  Copyright © 2019 com.ayong.myapp. All rights reserved.
//

import UIKit

class YYTabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        subVC()
        self.tabBar.tintColor = .green
    }
    
    func subVC() {
        let home = HomeViewController()
        let homeNav = YYNavViewController(rootViewController: home)
        homeNav.tabBarItem = UITabBarItem.init(title: "题库", image: UIImage(named: "tabbar_home"), selectedImage: UIImage(named: "tabbar_home"))
        
        let course = MessageViewController()
        let courseNav = YYNavViewController(rootViewController: course)
        courseNav.tabBarItem = UITabBarItem.init(title: "课程", image: UIImage(named: "tabbar_home"), selectedImage: UIImage(named: "tabbar_home"))

        let mine = MyViewController()
        let mineNav = YYNavViewController(rootViewController: mine)
        mineNav.tabBarItem = UITabBarItem.init(title: "我的", image: UIImage(named: "tabbar_home"), selectedImage: UIImage(named: "tabbar_home"))
        
        self.addChild(homeNav)
        self.addChild(courseNav)
        self.addChild(mineNav)
    }
    
}
