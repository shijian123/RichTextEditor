//
//  UIColor+Extension.swift
//  HeroGameBox
//
//  Created by zcy on 2020/12/3.
//

import UIKit

@objc public extension UIColor {
    
    /// 带透明度的16进制色值得到颜色
    /// - Parameters:
    ///   - hexString: 16进制色值
    ///   - alpha: 透明度 0-1.0
    convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
        
    }
    
    /// 使用RGB数值得到颜色
    ///
    /// - Parameters:
    ///   - r: 红 0-255.0
    ///   - g: 绿 0-255.0
    ///   - b: 蓝 0-255.0
    ///   - a: 透明度 0-1.0
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
    
    /// 设置深色和浅色两种颜色
    /// - Parameters:
    ///   - lightColor: 浅色色值 字符串
    ///   - darkColor: 深色色值 字符串
    static func colorWith(lightColor: String, lightColorAlpha: CGFloat = 1.0, darkColor: String, darkColorAlpha: CGFloat = 1.0) -> UIColor {
        
        if #available(iOS 13.0, *) {
            return UIColor.init { (traitCollection) in
                if traitCollection.userInterfaceStyle == .light {
                    return UIColor(hexString: lightColor, alpha: lightColorAlpha)!
                }else {
                    return UIColor(hexString: darkColor, alpha: darkColorAlpha)!
                }
            }
        } else {
            return UIColor(hexString: lightColor, alpha: lightColorAlpha)!
        }
    }
}
