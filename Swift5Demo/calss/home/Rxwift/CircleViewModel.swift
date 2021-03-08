//
//  CircleViewModel.swift
//  ColourfulBall
//
//  Created by Lukasz Mroz on 19.03.2016.
//  Copyright © 2016 Droids On Roids. All rights reserved.
//

//  This ViewModel is made to extract the logic of creating UIColor based on center of a view.
//  Every time new center is produced, we grab it and transform it to specifc UIColor. Then
//  ViewController can use it to redraw the view.
//
//  If you want to try your Rx skills I'd suggest to add another observable with e.g. width/height that
//  the ball could have change based on the center.
//

import ChameleonFramework
import Foundation
import RxSwift

class CircleViewModel {
    
    var centerVariable = Variable<CGPoint?>(.zero) // Create one variable that will be changed and observed
    var backgroundColorObservable: Observable<UIColor>! // Create observable that will change backgroundColor based on center
    fileprivate let disposeBag = DisposeBag()
    
    init() {
        setup()
    }
    
    func setup() {
        // When we get new center, emit new UIColor
        backgroundColorObservable = centerVariable.asObservable()
            .map { center in
                guard let center = center else { return UIColor.flatten(.black)() }
                
                let red: CGFloat = ((center.x + center.y).truncatingRemainder(dividingBy: 255.0)) / 255.0 // We just manipulate red, but you can do w/e
                let green: CGFloat = 0.0
                let blue: CGFloat = 0.0
                
                return UIColor.flatten(UIColor(red: red, green: green, blue: blue, alpha: 1.0))()
            }
    }
    
}
