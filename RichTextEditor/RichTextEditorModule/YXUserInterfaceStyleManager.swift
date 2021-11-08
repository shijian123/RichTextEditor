//
//  YXUserInterfaceStyleManager.swift
//  HeroGameBox
//
//  Created by zdd on 2021/8/25.
//

import UIKit
import SwiftyUserDefaults

class YXUserInterfaceStyleManager: NSObject {
 
    /// 是否为浅色模式
    var isLight: Bool {
        get {
            return isLightMode()
        }
    }

    private static let staticInstance = YXUserInterfaceStyleManager()
    
    @discardableResult static func shared() -> YXUserInterfaceStyleManager{
        return staticInstance
    }
    
    private override init() {
        super.init()
    }
    
    /// 当前的环境模式是否为浅色
    func isLightMode() -> Bool {
        
        if #available(iOS 13.0, *) {
            return UIApplication.shared.keyWindow?.traitCollection.userInterfaceStyle == .light
        }else {
            return true
        }
    }
    
    func getScreenInterfaceStyleString() -> String {
        return isLight ? "white" : "dark"
    }
}
