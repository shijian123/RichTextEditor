//
//  YX+Extension.swift
//  RichTextEditor
//
//  Created by zcy on 2021/11/9.
//

import UIKit
import IQKeyboardManagerSwift
import SDWebImage

// MARK: -
extension DispatchQueue {
    private static var _onceToken = [String]()
    
    class func once(token: String = "\(#file):\(#function):\(#line)", block: ()->Void) {
        objc_sync_enter(self)
        
        defer {
            objc_sync_exit(self)
        }

        if _onceToken.contains(token) {
            return
        }

        _onceToken.append(token)
        block()
    }
}

// MARK: -
public extension String {
    
    /// 是否为空字符串或者全是空格
    func isEmpty() -> Bool {
        if self.count > 0 {
            let set = NSCharacterSet.whitespacesAndNewlines
            let str = self.trimmingCharacters(in: set)
            if str.count == 0 {
                return true
            }else {
                return false
            }
        }else {
            return true
        }
    }
    
    /// 截取子字符串
    /// - Parameter index: to值，超出范围则返回字符串
    /// - Returns: 返回截取的子字符串
    func substring(to index: Int) -> String {
        if self.count > index {
            let endIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[self.startIndex..<endIndex]
            return String(subString)
        } else {// 终止值超出字符串范围，则返回字符串
            return self
        }
    }
    
    /// 将Rang转为NSRange
    func yx_Range(from range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }
    
    /// 是否为GIF图url
    func isGifImageUrlString() -> Bool {
        let fileName = URL(string: self)?.pathExtension
        
        if (fileName ?? "").lowercased() == "gif" {
            return true
        }
        return false
    }
    
    /// 贴子列表缩略图展示
    func resizeImageUrl() -> String {
        var imgUrl = self
        imgUrl += "?x-oss-process=image/resize,w_750/quality,q_60/interlace,1/format,webp"
        return imgUrl
    }
    
    /// 正则表达式匹配
    func match(pattern: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let results = regex.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            return results.count > 0
        } catch  {
            return false
        }
    }
    
    /// 匹配字符串内的URL
    /// - Returns: 返回URL数组
    func matchURLList() -> [String] {
        let urlReg = "(https?)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]"
        let urlArr = YXHtmlEditTool.match(self, toRegexString: urlReg) as! [String]
        return urlArr
    }
    
}

// MARK: 自定义表情包

extension String {
    /// 匹配字符串内的自定义表情包
    /// - Returns: 返回自定义表情的字符串
    func matchCustomEmoji() -> [String] {
        let imgReg = "_\\[/[\\u4e00-\\u9fa5-a-zA-Z]*]"
        let imgArr = YXHtmlEditTool.match(self, toRegexString: imgReg) as! [String]
        return imgArr
    }
    
    /// 表情包是否为大图
    func isLargeEmoji() -> Bool {
        var isLarge = false
        if self.contains("bigImg-") {
            isLarge = true
        }
        return isLarge
    }
}


// MARK: -
public extension UIButton {
    /// 避免重复点击设置间隔为1s
    func avoidRepeatMethod() {
        self.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isEnabled = true
        }
    }
}

// MARK: -
extension UIImageView {
    
    /// 设置图片加载
    /// - Parameters:
    ///   - urlStr: 图片地址
    func setImage(with urlStr: String) -> Void {
        self.sd_setImage(with: URL(string: urlStr))
    }
    
    /// 设置图片加载
    /// - Parameters:
    ///   - urlStr: 图片地址
    ///   - placeholderImgStr: 占位图
    ///   - force: 强制先从缓存中查找
    func setImage(with urlStr: String,
                  placeholderImgStr: String, force: Bool = false) -> Void {
        if force {
            
            let cache: SDImageCache = SDWebImageManager.shared.imageCache as! SDImageCache
            if let image = cache.imageFromMemoryCache(forKey: urlStr) {
                self.image = image
            }else if let image = cache.imageFromDiskCache(forKey: urlStr) {
                self.image = image
            }else {
                self.sd_setImage(with: URL(string: urlStr), placeholderImage: UIImage(named: placeholderImgStr))
            }
        }else {
            self.sd_setImage(with: URL(string: urlStr), placeholderImage: UIImage(named: placeholderImgStr))
        }
    }
    
    

    /// 图片加载
    /// - Parameters:
    ///   - urlStr: 图片地址
    ///   - placeholderImgStr: 占位图
    ///   - options: options
    ///   - completionHandler: 完成回调
    func setImage(with urlStr: String,
                  placeholderImgStr: String, options: SDWebImageOptions = [], completionHandler: ((_ image: UIImage?, _ error: Error?)-> Void)?) -> Void {
        self.sd_setImage(with: URL(string: urlStr), placeholderImage: UIImage(named: placeholderImgStr), options: options) { image, error, _, _ in
            completionHandler?(image, error)
        }
    }

    /// 图片加载
    /// - Parameters:
    ///   - urlStr: 图片地址
    ///   - placeholderImgStr: 占位图
    ///   - options: options
    ///   - completionHandler: 完成回调
    func setImage(with urlStr: String,
                  placeholderImg: Any, options: SDWebImageOptions = [],  progress: @escaping SDImageLoaderProgressBlock, completionHandler: SDExternalCompletionBlock?) -> Void {
        
        var placeholder: UIImage = UIImage()
        
        if let placeholderImgStr = placeholderImg as? String {
            placeholder = UIImage(named: placeholderImgStr)!
        }
        
        if let image = placeholderImg as? UIImage {
            placeholder = image
        }
        
        self.sd_setImage(with: URL(string: urlStr), placeholderImage: placeholder, options: options, progress: progress, completed: completionHandler)
    }

    
    /// 设置图片加载
    /// - Parameters:
    ///   - urlStr: 图片地址
    ///   - placeholderImgStr: 占位图
    ///   - options: 图片配置
    ///   - errorImgStr: 异常占位图
    ///   - isAbnormal: 是否为违禁图
    ///   - isShowGif: 是否播放gif
    func setImage(with urlStr: String,
                  placeholderImgStr: String,
                  options: SDWebImageOptions = [],
                  errorImgStr: String?, isAbnormal: Bool, isShowGif: Bool, completionHandler: ((_ image: UIImage?, _ error: Error?)-> Void)?) -> Void {
                
        if isAbnormal {
            self.image = UIImage(named: errorImgStr ?? "")
            if urlStr.isGifImageUrlString() {// 是否为gif图
                if let gifImgViwe = self as? YXImageView {
                    gifImgViwe.showGifTag = true
                }
            }
        }else {

            var newUrlStr = urlStr
            if isShowGif == false {
                
                if urlStr.isGifImageUrlString() {
                    if urlStr.contains("x-oss-process") {// 已设置
                        if urlStr.contains("format,webp") {
                            newUrlStr = urlStr.replacingOccurrences(of: "format,webp", with: "format,png")
                        }else {
                            newUrlStr = urlStr + "/format,png"
                        }
                    }else {
                        newUrlStr = urlStr + "?x-oss-process=image/format,png"
                    }
                    if let gifImgViwe = self as? YXImageView {
                        gifImgViwe.showGifTag = true
                    }
                }
            }
            
            self.sd_setImage(with: URL(string: newUrlStr), placeholderImage: UIImage(named: placeholderImgStr), options: []) {[weak self] image, error, cacheType, url in
                if error != nil {
                    self?.image = UIImage(named: errorImgStr ?? "")
                }

                completionHandler?(image, error)
            }
            
            self.layer.removeAnimation(forKey: "transition")
        }
    }
}


// MARK: -
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
    
    fileprivate static func showText(_ text: String, view: UIView, afterDelay: Double) {
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


