//
//  ActiveLabelViewController.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/1/16.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit
import ActiveLabel

class ActiveLabelViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label1 = ActiveLabel()
        view.addSubview(label1)
        label1.snp.makeConstraints { (make) in
            make.top.equalTo(100)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        let label2 = ActiveLabel()
        view.addSubview(label2)
        label2.snp.makeConstraints { (make) in
            make.top.equalTo(label1.snp_bottom).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        let label3 = ActiveLabel()
        view.addSubview(label3)
        label3.snp.makeConstraints { (make) in
            make.top.equalTo(label2.snp_bottom).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        let customType = ActiveType.custom(pattern: "百度") //Looks for "百度"
        label1.enabledTypes.append(customType)
        label1.urlMaximumLength = 50
        label1.customize { (lab) in
            lab.text = "自定义点击百度"
            lab.textColor = .green
            lab.customColor[customType] = UIColor.purple
            lab.customSelectedColor[customType] = UIColor.yellow
            lab.configureLinkAttribute = {(type, attributes, isSelected) in
                var atts = attributes
                switch type {
                case customType:
                    atts[NSAttributedString.Key.font] = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.boldSystemFont(ofSize: 14)
                default: ()
                }
                return atts
            }
            
            lab.handleCustomTap(for: customType) {
                self.alert("Custom type", message: $0)
            }
        }
        
        
        label2.customize { (lab) in
            lab.text = "网址\nhttps://swift.org/blog/conditional-conformance/"
            lab.numberOfLines = 0
            lab.lineSpacing = 4

            lab.hashtagColor = .red
            lab.mentionColor = .yellow
            lab.URLSelectedColor = .blue
            lab.URLColor = .green
            lab.handleURLTap {
                self.alert("点击url", message: $0.absoluteString)
            }
        }
        
        let customType3 = ActiveType.custom(pattern: "\\s百度\\b") //Looks for "it"
        label3.enabledTypes.append(customType3)
        label3.customize { label in
            label.text = "This is a post 百度  用户协议 with #multiple #hashtags and a @userhandle. Links are also supported like" +
            " this one: http://optonaut.co. Now 用户协议 also supports custom patterns -> are\n\n" +
                "Let's trim a long link: \nhttps://twitter.com/twicket_app/status/649678392372121601"
            label.numberOfLines = 0
            label.lineSpacing = 4
            
            label.textColor = UIColor(red: 102.0/255, green: 117.0/255, blue: 127.0/255, alpha: 1)
            label.hashtagColor = UIColor(red: 85.0/255, green: 172.0/255, blue: 238.0/255, alpha: 1)
            label.mentionColor = UIColor(red: 238.0/255, green: 85.0/255, blue: 96.0/255, alpha: 1)
            label.URLColor = UIColor(red: 85.0/255, green: 238.0/255, blue: 151.0/255, alpha: 1)
            label.URLSelectedColor = UIColor(red: 82.0/255, green: 190.0/255, blue: 41.0/255, alpha: 1)

            label.handleMentionTap { self.alert("Mention", message: $0) }
            label.handleHashtagTap { self.alert("Hashtag", message: $0) }
            label.handleURLTap { self.alert("URL", message: $0.absoluteString) }

            //Custom types
            label.customColor[customType3] = UIColor.purple
            label.customSelectedColor[customType3] = UIColor.green
            
            label.configureLinkAttribute = { (type, attributes, isSelected) in
                var atts = attributes
                switch type {
                case customType3:
                    atts[NSAttributedString.Key.font] = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.boldSystemFont(ofSize: 14)
                default: ()
                }
                
                return atts
            }
            label.handleCustomTap(for: customType3) { self.alert("Custom type", message: $0) }
        }
    }
    
    func alert(_ title: String, message: String) {
        let vc = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        vc.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(vc, animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
