//
//  UIImageView+Extension.swift
//  HeroGameBox
//
//  Created by zcy on 2021/4/28.
//

import UIKit
import SDWebImage

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
