//
//  AppSupport.swift
//  ToDoList
//
//  Created by Ishaq Shafiq on 12/09/2017.
//  Copyright © 2017 Ishaq Shafiq. All rights reserved.
//

import Foundation
import UIKit

class AppSupport {
    
    class func addAnimation( toView: UIView! , withDuration: Float) {
        let transition = CATransition()
        transition.duration = CFTimeInterval(withDuration)
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        toView.layer.add(transition, forKey: nil)
    }
}
