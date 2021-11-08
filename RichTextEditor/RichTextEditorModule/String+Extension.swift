//
//  String+Extension.swift
//  HeroGameBox
//
//  Created by zcy on 2020/12/3.
//

import UIKit

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
    
    /// 字符串是否为nil或者是空串
    func isEmptyString(_ str: String?) -> Bool {
        return str == nil || str! == ""
    }

    /// 返回默认空串，如果字符串是否为ni，返回""
    func defauseEmptyString(_ str: String?) -> String {
        return str ?? ""
    }
    
    
    /// 贴子计算，按万算
    /// - Returns: 超过一万，以万为单位
    func addNumUnit() -> String {
        if let num = Double(self) {
            if num >= 10000 {
                return "\(Int(num / 10000))万"
            }
        }
        return self
    }
    
    /// 截取子字符串
    /// - Parameter index: from值，超出范围则返回空字符串
    /// - Returns: 返回截取的子字符串
    func substring(from index: Int) -> String {
        if self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[startIndex..<self.endIndex]
            return String(subString)
        } else {// 起始值超出字符串范围，则返回空字符串
            return ""
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
    
}

public extension String {
    
    /// 是否为GIF图url
    func isGifImageUrlString() -> Bool {
        let fileName = URL(string: self)?.pathExtension
        
        if (fileName ?? "").lowercased() == "gif" {
            return true
        }
        return false
    }
    
    /// 根据指定字体和宽度得到string的size
    ///
    /// - Parameter font: 指定大小
    /// - Parameter constrainedWidth: 限定宽度
    /// - Parameter lineBreakMode: 换行mode
    /// - Parameter lineSpacing: 行间距
    /// - Returns: string的size
    func sizeWith(font: UIFont, constrainedWidth: CGFloat, textAlignment:
        NSTextAlignment = NSTextAlignment.left, lineBreakMode: NSLineBreakMode = NSLineBreakMode.byWordWrapping, lineSpacing: CGFloat = 0.0) -> CGSize {

        let constrainedRect = CGSize(width: constrainedWidth, height: CGFloat.greatestFiniteMagnitude)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineBreakMode = lineBreakMode
        paragraphStyle.lineSpacing = lineSpacing

        let boundingBox = self.boundingRect(with: constrainedRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle], context: nil)
        return boundingBox.size
    }
    
    /// 根据指定字体和高度得到string的size
    /// - Parameters:
    ///   - font: 字体大小
    ///   - constrainedHeight: 限定高度
    ///   - lineBreakMode: 换行mode
    ///   - lineSpacing: 行间距
    /// - Returns: string的size
    func sizeWith(font: UIFont, constrainedHeight: CGFloat, textAlignment:
        NSTextAlignment = NSTextAlignment.left, lineBreakMode: NSLineBreakMode = NSLineBreakMode.byWordWrapping, lineSpacing: CGFloat = 0.0) -> CGSize {

        let constrainedRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: constrainedHeight)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineBreakMode = lineBreakMode
        paragraphStyle.lineSpacing = lineSpacing

        let boundingBox = self.boundingRect(with: constrainedRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle], context: nil)
        return boundingBox.size
    }
    
    //获取字符的宽度
    func stringWidth(_ font:UIFont) ->CGFloat {
        
        let size: CGSize = self.size(withAttributes: [kCTFontAttributeName as NSAttributedString.Key:font])
        return size.width
    }
    
    /// 判断字符串中是否有中文
    func isIncludeChinese() -> Bool {
        for ch in self.unicodeScalars {
             if (0x4e00 < ch.value  && ch.value < 0x9fff) { return true } // 中文字符范围：0x4e00 ~ 0x9fff
        }
        return false
    }
    
    /// 将中文字符串转换为拼音
    ///
    /// - Parameter hasBlank: 是否带空格（默认不带空格）
    func transformToPinyin(hasBlank: Bool = false) -> String {
        let stringRef = NSMutableString(string: self) as CFMutableString
        CFStringTransform(stringRef,nil, kCFStringTransformToLatin, false) // 转换为带音标的拼音
        CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false) // 去掉音标
        let pinyin = stringRef as String
        return hasBlank ? pinyin : pinyin.replacingOccurrences(of: " ", with: "")
    }
    
    /// 获取中文首字母
    ///
    /// - Parameter lowercased: 是否小写（默认大写）
    func transformToPinyinHead(lowercased: Bool = false) -> String {
         let pinyin = self.transformToPinyin(hasBlank: true).capitalized // 字符串转换为首字母大写
            var headPinyinStr = ""
           for ch in pinyin {
               if ch <= "Z" && ch >= "A" {
                  headPinyinStr.append(ch) // 获取所有大写字母
            }
          }
        return lowercased ? headPinyinStr.lowercased() : headPinyinStr
    }
    
    
}

// MARK: - 正则

extension String {

    /// 是否为合规的密码
    func isPassWord() -> Bool {
        return self.match(pattern: "^(?=.*[a-zA-Z])(?=.*[0-9])[A-Za-z0-9]{8,15}$")
    }

    /// 是否是手机号
    func isPhoneNum() -> Bool {
        return self.match(pattern: "^1[0-9]\\d{9}$")
    }
    
    /// 是否纯数字且不超过30
    func isAccountNum() -> Bool {
        return self.match(pattern: "^([0-9]){1,30}$")
    }
    
    /// 是否为合规的昵称
    func isNiceName() -> Bool {
        let have = self.match(pattern: "^[\\u4e00-\\u9fa5a-zA-Z0-9]{2,10}$")
        return have
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

// MARK: - 自定义表情包

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
        if self.contains("创魔-") {
            isLarge = true
        }
        return isLarge
    }
}


// MARK: - 图片URL优化

extension String {
    
    /// 贴子列表缩略图展示
    func resizeImageUrl() -> String {
        var imgUrl = self
        imgUrl += "?x-oss-process=image/resize,w_750/quality,q_60/interlace,1/format,webp"
        return imgUrl
    }
    
    /// 头像地址缩略图
    func resizeHeadImageUrl() -> String {
        let imgUrl = self + "?x-oss-process=image/resize,w_750/quality,q_60/interlace,1/format,webp"
        return imgUrl
    }

}

// MARK: - 富文本

extension String {
    
    /// 根据指定参数得到富文本
    ///
    /// - Parameters:
    ///   - characterSpacing: 字符间距
    ///   - lineSpacing: 行间距
    ///   - textAlignment: 对齐方式
    ///   - lineBreakMode: 换行mode
    /// - Returns: 富文本
    func attributeStringWith(characterSpacing: CGFloat, lineSpacing: CGFloat = 0.0, textAlignment:
        NSTextAlignment = NSTextAlignment.left, lineBreakMode: NSLineBreakMode = NSLineBreakMode.byWordWrapping) -> NSAttributedString {

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineBreakMode = lineBreakMode
        paragraphStyle.lineSpacing = lineSpacing
        let attributedString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.kern: characterSpacing, NSAttributedString.Key.paragraphStyle:paragraphStyle])

        
        return attributedString
    }
    
}

/*
 extension String {
     /// 是否为单个emoji表情
     var isSingleEmoji: Bool {
         return count==1&&containsEmoji
     }

     /// 包含emoji表情
     var containsEmoji: Bool {
         return contains{ $0.isEmoji}
     }

     /// 只包含emoji表情
     var containsOnlyEmoji: Bool {
         return !isEmpty && !contains{!$0.isEmoji}
     }

     /// 提取emoji表情字符串
     var emojiString: String {
         return emojis.map{String($0) }.reduce("",+)
     }

     /// 提取emoji表情数组
     var emojis: [Character] {
         return filter{ if #available(iOS 10.2, *) {
             $0.isEmoji
         } else {
             // Fallback on earlier versions
         }}
     }

     /// 提取单元编码标量
     var emojiScalars: [UnicodeScalar] {
         return filter{ if #available(iOS 10.2, *) {
             $0.isEmoji
         } else {
             // Fallback on earlier versions
         }}.flatMap{ $0.unicodeScalars}
     }
 }

 */
