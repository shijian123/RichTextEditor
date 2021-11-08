//
//  YXConst.swift
//  HeroGameBox
//
//  Created by zcy on 2020/12/3.
//

import Foundation
import UIKit


//MARK: ------------------ 代码配置项 ------------------

let openNetLog = true
let openControllerDisappearLog = false


//MARK: ------------------ 文案相关 ------------------

/// 标题的行间距
let YXTitleLineSpacing: CGFloat = 8
/// 内容的行间距
let YXContentLineSpacing: CGFloat = 6
/// 评论的行间距
let YXReplyLineSpacing: CGFloat = 6

//MARK: ------------------ APP信息相关 ------------------

/// bundle ID
public let YXBundleID = Bundle.main.bundleIdentifier!
/// App显示名
public let YXDisplayName = Bundle.main.infoDictionary!["CFBundleDisplayName"] ?? ""
/// 主版本号
public let YXVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"]!
/// build编号
public let YXBuildVersion = Bundle.main.infoDictionary!["CFBundleVersion"]!

/// 邮箱
public let YXMailbox = "herobox@yingxiong.com"
/// 意见反馈群
public let YXFeedbackGroup = "118261803" 




//MARK: ------------------ 屏幕相关 ------------------

let iPhone6S: Bool = __CGSizeEqualToSize(CGSize(width: 750, height: 1334), UIScreen.main.currentMode?.size ?? CGSize(width: 0, height: 0));

let YXMainScreenSize = UIScreen.main.bounds.size

let YXMainScreenWidth: CGFloat = UIScreen.main.bounds.size.width
let YXMainScreenHeight: CGFloat = UIScreen.main.bounds.size.height
let YXScreenBottomH: CGFloat = (isBangsScreen ? 34.0 : 0)
let YXStatusBarHight: CGFloat = CGFloat(getStatusBarHight())
let YXNavBarHight: CGFloat = (CGFloat(getStatusBarHight()) + 44.0)
let YXTabBarHight: CGFloat = (YXScreenBottomH + 49.0)
let YXTitleBarHight: CGFloat = 42.0

/// 是否iPad
let isPad = UIDevice.current.userInterfaceIdiom == .pad

/// 是否是刘海屏
let isBangsScreen = isBangsScreenIPhone()


/// 是否为刘海屏
func isBangsScreenIPhone() -> Bool {
    if #available(iOS 11.0, *) { // 刘海屏手机至少是iOS11
        return (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0) > 0
    } else {
        return false
    }
}

/// 状态栏高度
func getStatusBarHight() -> Int {
    
    var statusBarHeight = 0
    
    if #available(iOS 13.0, *) { // 刘海屏手机至少是iOS11
        let statusBarManager = UIApplication.shared.windows.first?.windowScene?.statusBarManager
        statusBarHeight = Int(statusBarManager?.statusBarFrame.size.height ?? 44)
    } else {
        statusBarHeight = Int(UIApplication.shared.statusBarFrame.size.height)
    }
    return statusBarHeight

}

/// 当前系统是否为iOS11
func isiOS11System() -> Bool {
    var isiOS11 = false
    if #available(iOS 11.0, *) {
        if #available(iOS 12.0, *) {
        }else {
            isiOS11 = true
        }
    }
    return isiOS11
}

protocol Nibloadable { }

extension Nibloadable {
    
    static func loadFromNib() -> Self? {
        return Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.first as? Self
    }
}



