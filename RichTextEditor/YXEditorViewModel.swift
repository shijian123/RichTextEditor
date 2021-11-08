//
//  YXEditorViewModel.swift
//  RichTextEditor
//
//  Created by zcy on 2021/11/3.
//

import UIKit

typealias YXTextAction = ((_ containerView: UIView, _ text: NSAttributedString, _ range: NSRange, _ rect: CGRect, _ originStr: String) -> Void)

class YXEditorViewModel: NSObject {
    /// 评论内容的图片URL数组
    var imgUrlArr: [String] = []
    /// 评论内容的相对应的imageView数组
    var imgViewArr: [UIImageView] = []
    /// 图片的tag，从101
    var imgTagNum = 100

    
    var cardModelArr: [YXPostLinkCardModel] = []
    var cardTagNum = 100
    
    
}

// MARK: - 显示富文本内容

extension YXEditorViewModel {
    /// 生成富文本内容（贴子、评论、回复）
    /// - Parameters:
    ///   - list: 内容list
    ///   - isPost: 是否为贴子，默认为false
    /// - Returns: 内容富文本字符串
    func creatContent(contentList list: [YXPostContentModel], isPost: Bool = false, tapAction: YXTextAction? = nil, longPressAction: YXTextAction? = nil) -> NSMutableAttributedString {
        // 清空数组
        imgUrlArr = []
        imgViewArr = []
        imgTagNum = 100
        
        let text = NSMutableAttributedString(string: "")
        
        for i in 0..<list.count {
            let model = list[i]
            if model.contentType == "1" {// 文本
                
                let attributedStr = self.creatTextContent(model: model, isPost: isPost, tapAction: tapAction, longPressAction: longPressAction)
                text.append(attributedStr)

                
            }else if model.contentType == "2" {// 图片
                let attachment = self.creatImageContent(model: model, isPost: isPost)
                text.append(attachment)
                if i != list.count-1 {
                    text.append(NSAttributedString(string: " \n\n"))
                }
            }else if model.contentType == "3" {// 卡片
                let attachment = self.creatCardContent(model: model)
                text.append(attachment)
            }
        }
        
        return text
    }
    
    
    /// 生成文字内容富文本
    /// - Parameters:
    ///   - model: 贴子内容model
    ///   - isPost: 是否为贴子
    ///   - tapAction: 点击事件
    ///   - longPressAction: 长按事件
    /// - Returns: 文字内容富文本
    func creatTextContent(model: YXPostContentModel, isPost: Bool = false, tapAction: YXTextAction? = nil, longPressAction: YXTextAction? = nil) -> NSMutableAttributedString {
        var contentStr = model.content
        
        var contentFont = UIFont.systemFont(ofSize: 14)
        if isPost {
            contentFont = UIFont.systemFont(ofSize: 16)
        }
        
        if !isPost {
            // 清除评论的头尾空格、换行
            contentStr = contentStr?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        // 默认字色
        var textColor = UIColor.black
        var attributedStr = NSMutableAttributedString()

        if (contentStr?.count ?? 0) > 0 {
            
            // 修改行间距
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = YXContentLineSpacing
            paragraphStyle.paragraphSpacing = YXContentLineSpacing
            
            if isPost {// 展示贴子
                
                textColor = (YXUserInterfaceStyleManager.shared().isLight ? UIColor(hexString: "0x000000", alpha: 0.8) : UIColor(hexString: "0xFFFFFF", alpha: 0.8))!
            
                attributedStr = NSMutableAttributedString(string: contentStr ?? "", attributes: [ NSAttributedString.Key.paragraphStyle:paragraphStyle, NSAttributedString.Key.foregroundColor: textColor,NSAttributedString.Key.font: contentFont
                ])
            }else {
                textColor = (YXUserInterfaceStyleManager.shared().isLight ? UIColor(hexString: "0x000000", alpha: 0.8) : UIColor(hexString: "0xF9F9F9", alpha: 1.0))!
                
                attributedStr = NSMutableAttributedString(string: contentStr ?? "", attributes: [ NSAttributedString.Key.paragraphStyle:paragraphStyle, NSAttributedString.Key.foregroundColor: textColor])
            }
            
            // 将表情包文案替换为表情图片
            self.replaceCustomEmoji(attributedStr)
            
        }
        return attributedStr
    }
    
    /// 生成图片内容富文本
    /// - Parameters:
    ///   - model: 贴子内容model
    ///   - isPost: 是否为贴子
    /// - Returns: 图片内容富文本
    func creatImageContent(model: YXPostContentModel, isPost: Bool = false) -> NSMutableAttributedString {
        
        var attachment = NSMutableAttributedString()
        var contentFont = UIFont.systemFont(ofSize: 14)
        if isPost {
            contentFont = UIFont.systemFont(ofSize: 16)
        }
        
        var imgHeight = Float(model.imgHeight ?? "1")!
        var imgWidth = Float(model.imgWidth ?? "1")!
        if imgWidth <= 0 {
            imgWidth = 100
        }
        if imgHeight <= 0 {
            imgHeight = 100
        }
        
        // 手动设置，防止约束不准确
        var img_W: CGFloat = 0.0
        if isPost {
            img_W = YXMainScreenWidth - 32
        }else {
            img_W = YXMainScreenWidth - 80
        }
        let num = imgHeight*Float(img_W)
        let img_H = num / imgWidth
        let imageV = YXImageView(frame: CGRect(x: 0, y: 0, width: img_W, height: CGFloat(img_H)))
        imageV.layer.masksToBounds = true
        imageV.layer.cornerRadius = 8
        
        let urlStr = model.url?.resizeImageUrl() ?? ""
        imageV.setImage(with: urlStr, placeholderImgStr: "base_default_03.png", errorImgStr: "base_default_error_03.png", isAbnormal: model.isAbnormal, isShowGif: false, completionHandler: nil)
        imageV.contentMode = .scaleAspectFill
        // 设置点击图片的配置
        imgTagNum += 1
        imageV.tag = imgTagNum
        if model.isAbnormal {
            imgUrlArr.append("isAbnormal")
        }else {
            imgUrlArr.append(model.url ?? "")
        }
        imgViewArr.append(imageV)

        
        attachment = NSMutableAttributedString.yy_attachmentString(withContent: imageV, contentMode: .bottom, attachmentSize: imageV.size, alignTo: contentFont, alignment: .center)
        attachment.yy_setTextHighlight(NSRange(location: 0, length: attachment.length), color: .clear, backgroundColor: .clear) { (view, attri, range, rect) in
            self.clickImageMethod(tagNum: imageV.tag)
        }
        
        return attachment
        
    }

    
    func creatCardContent(model: YXPostContentModel) -> NSMutableAttributedString {
        var attachment = NSMutableAttributedString()
        let contentFont = UIFont.systemFont(ofSize: 14)
        
        if let cardModel = model.contentLink {
            let cardView = YXLinkCardView(model: cardModel)
            
            // 设置点击卡片的配置
            cardTagNum += 1
            cardView.tag = cardTagNum
            cardModelArr.append(cardModel)
            
            attachment = NSMutableAttributedString.yy_attachmentString(withContent: cardView, contentMode: .bottom, attachmentSize: cardView.size, alignTo: contentFont, alignment: .center)
            attachment.yy_setTextHighlight(NSRange(location: 0, length: attachment.length), color: .clear, backgroundColor: .clear) { (view, attri, range, rect) in
                self.clickLinkCardMethod(tagNum: cardView.tag)
            }
        }
        
        return attachment
    }
    
    /// 替换自定义表情符
    /// - Parameter text: 原始字符串
    func replaceCustomEmoji(_ text: NSMutableAttributedString) {
        var attachment = NSMutableAttributedString()
        let font = UIFont.systemFont(ofSize: 16)
        
        var emojiArr:[YXEmojiItemModel] = []
        for group in YXEmojiDataManager.manager.emojiPackages {
            emojiArr += group.emojis ?? []
        }
        
        let content = text.string
        let imgArr = content.matchCustomEmoji()
        for i in 0..<imgArr.count {
            let imgStr = imgArr[imgArr.count-1-i]
            for model in emojiArr {
                if imgStr == "_\(model.desc ?? "")" {
                    let range = text.string.range(of: imgStr)!
                    let range1 = imgStr.yx_Range(from: range)
                    let imageV = UIImageView()
                    if imgStr.isLargeEmoji() {// 大图
                        imageV.size = CGSize(width: 60, height: 60)
                    }else {
                        imageV.size = CGSize(width: 30, height: 30)
                    }
                    imageV.image = UIImage(contentsOfFile: model.imagePath ?? "")
                    attachment = NSMutableAttributedString.yy_attachmentString(withContent: imageV, contentMode: .center, attachmentSize: imageV.size, alignTo: font, alignment: .bottom)
                    
                    // 修改行间距
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineSpacing = YXContentLineSpacing
                    paragraphStyle.paragraphSpacing = YXContentLineSpacing
                    attachment.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: attachment.yy_rangeOfAll())
                    text.replaceCharacters(in: range1, with: attachment)
                }
            }
        }
    }
    
    func clickImageMethod(tagNum: Int) {
        
        let row = tagNum - 101
        if row >= 0 {
            let urlStr = imgUrlArr[row]
            if urlStr.isGifImageUrlString() {
                if let gifImgV = imgViewArr[row] as? YXImageView {
                    if gifImgV.showGifTag {// 如果有gif图标则需先加载gif
                        YXPhotoShowTool.loadGifImgView(gifImgV, urlStr)
                        return
                    }
                }
            }
            YXPhotoShowTool.showBigImgsMethod(imgUrlArr, row: row, imgViews: imgViewArr)
        }
    }
    
    func clickLinkCardMethod(tagNum: Int) {
        // 查看网页
        let context = ["url": "", "title": "", "canBack": true, "isSafeLoad": true] as [String : Any]
//        navigator.push(RouterPath.openWebPage.rawValue, context: context)
    }
}

