//
//  GreetingViewController.swift
//  Swift5Demo
//
//  Created by 阿永 on 2022/8/23.
//  Copyright © 2022 com.ayong.myapp. All rights reserved.
//

import UIKit

class GreetingViewController: UIViewController, GreetingView{

    var presenter: GreetingViewPresenter!
    
    var showGreetingButton: UIButton!
    var greetingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor .black
        self.setupUIElements()
        
        // mvp
        let model = Person(firstName: "Wasin", lastName: "Thonkaew")
        let presenter = GreetingPresenter(view: self, person: model)
        self.presenter = presenter
    }
    
    //MARK: - action
    @objc func didTapButton(sender: UIButton) {
        self.presenter.showGreeting()
    }
    
    //MARK: - ui
    func setupUIElements() {
        self._setupButton()
        self._setupLabel()
    }
    
    private func _setupButton() {
        self.showGreetingButton = UIButton()
        self.showGreetingButton.frame = CGRect(x: 50, y: 200, width: 200, height: 20)
        self.showGreetingButton.setTitle("Click me", for: .normal)
        self.showGreetingButton.setTitle("You badass", for: .highlighted)
        self.showGreetingButton.setTitleColor(UIColor.white, for: .normal)
        self.showGreetingButton.setTitleColor(UIColor.red, for: .highlighted)
        self.showGreetingButton.translatesAutoresizingMaskIntoConstraints = false
        self.showGreetingButton.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
        self.view.addSubview(self.showGreetingButton)
    }
    
    private func _setupLabel() {
        self.greetingLabel = UILabel()
        self.greetingLabel.frame = CGRect(x: 100, y: 100, width: 200, height: 20)
        self.greetingLabel.textColor = UIColor.white
        self.greetingLabel.textAlignment = .center
        self.greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.greetingLabel.text = "lable 一点点"
        self.view.addSubview(self.greetingLabel)
    }
    
    //MARK: - GreetingView
    func setGreeting(greeting: String) {
        self.greetingLabel.text = greeting
    }
}
