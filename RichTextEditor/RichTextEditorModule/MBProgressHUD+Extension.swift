//
//  MBProgressHUD+Extension.swift
//  HeroGameBox
//
//  Created by zcy on 2020/12/7.
//

import UIKit
import IQKeyboardManagerSwift

public extension MBProgressHUD {
     
    static func showText(_ text: String) {
        guard let window = MBProgressHUD.frontWindow() else { return }
        showText(text, view: window, afterDelay: 1.0)
    }
    
    static func showText(_ text: String, afterDelay: Double) {
        guard let window = MBProgressHUD.frontWindow() else { return }
        showText(text, view: window, afterDelay: afterDelay)
    }
    
    /// 菊花动画
    @discardableResult
    static func showAddHud() -> MBProgressHUD {
        guard let window = MBProgressHUD.frontWindow() else { return MBProgressHUD()}
        let hud = MBProgressHUD.showAdded(to: window, animated: true)
        hud.bezelView.style = .solidColor
        hud.bezelView.blurEffectStyle = .light
        hud.bezelView.color = UIColor.colorWith(lightColor: "0xCCCCCC", darkColor: "0x33333E")

        return hud
    }
    
    static func hiddenHUD() {
        guard let window = MBProgressHUD.frontWindow() else { return }
        MBProgressHUD.hide(for: window, animated: true)
    }
    
    static func showText(on onView: UIView?, text: String, delay:Double) {
        
        guard let window = MBProgressHUD.frontWindow() else { return }
        var view = onView
        if view == nil {
            view = window
        }
        
        let hud = MBProgressHUD.showAdded(to: view!, animated: true)
        
        if text.count > 0 {
            hud.label.text=text
        }

        //hud显示的大小
        hud.minSize=CGSize.init(width: 200, height: 200)
        //hud动画的模式
        hud.animationType=MBProgressHUDAnimation.zoomIn
        
        hud.mode=MBProgressHUDMode.indeterminate;//带动画，默认值
        hud.removeFromSuperViewOnHide = true
        
        //延迟隐藏
        hud.hide(animated: true, afterDelay: delay)

    }
    
}

private extension MBProgressHUD {
    static func showText(_ text: String, view: UIView, afterDelay: Double) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.bezelView.style = .solidColor
        hud.bezelView.blurEffectStyle = .light
        hud.bezelView.color = UIColor(hexString: "0x000000", alpha: 0.8)
        hud.mode = .text
        hud.label.text = text
        hud.label.numberOfLines = 0
        hud.label.textColor = UIColor.colorWith(lightColor: "0xFFFFFF", darkColor: "0x979AA2")
        hud.hide(animated: true, afterDelay: afterDelay)
    }
}

extension MBProgressHUD {
    
    static func frontWindow() -> UIWindow? {
        
        for window in UIApplication.shared.windows.reversed() {
            
            guard window.screen == UIScreen.main else {
                continue
            }
            guard !window.isHidden && window.alpha > 0 else {
                continue
            }
            guard window.windowLevel >= .normal else {
                continue
            }
            guard !window.description.hasPrefix("<UITextEffectsWindow") else {
                continue
            }
            
            guard !window.description.hasPrefix("<UIRemoteKeyboardWindow") || IQKeyboardManager.shared.keyboardShowing else {
                continue
            }
            // 哆啦A梦的窗口
            guard !window.description.contains("Doraemon") else {
                continue
            }
            
            return window
            
        }
        return nil
    }
    
}

