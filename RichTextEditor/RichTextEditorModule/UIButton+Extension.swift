//
//  UIButton+Extension.swift
//  HeroGameBox
//
//  Created by zcy on 2020/12/17.
//

import UIKit

public extension UIButton {
    /// 避免重复点击设置间隔为1s
    func avoidRepeatMethod() {
        self.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isEnabled = true
        }
    }
}
