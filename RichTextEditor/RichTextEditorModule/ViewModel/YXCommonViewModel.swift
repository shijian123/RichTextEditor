//
//  YXCommonViewModel.swift
//  HeroGameBox
//
//  Created by zcy on 2021/2/26.
//

import UIKit
import SwiftSoup
import WebKit

class YXCommonViewModel: NSObject {
}

// MARK: 关于HTML

extension YXCommonViewModel {
    /// 整理html，过滤无效视图
    /// - Parameter html: 编辑器生成的html
    static func creatResetHtml(_ html: String) -> String {
        var htmlStr = html
        // 过滤无效视图
        let divReg = "<div class=[^>]*>.*?</div>"
        let divArray = YXHtmlEditTool.match(htmlStr, toRegexString: divReg) as! [String]
        if divArray.count > 0 {
            for objStr in divArray {
                if objStr.count > 0 && (objStr.contains("class=\"networkImage-f-div\"") || objStr.contains("class=\"networkErrorImage-f-div\"")){
                    let imgReg = "<img[^>]*>"
                    let imgArr = YXHtmlEditTool.match(objStr, toRegexString: imgReg) as! [String]
                    if imgArr.count > 0 {
                        let imgStr = "</p>\(imgArr[0])<p>"
                        htmlStr = htmlStr.replacingOccurrences(of: objStr, with: imgStr)
                    }
                }
            }
        }
        return htmlStr
    }
    
    /// 重置图片异常html
    static func resetImageErrorHtml(_ html: String) -> String {
        
        // 没有异常图片，直接返回html
        if !html.contains("imgLoadError") {
            return html
        }
        
        var htmlStr = html
        // 过滤无效视图
        let divReg = "<div[^>]*>.*?</div>"
        let divArray = YXHtmlEditTool.match(htmlStr, toRegexString: divReg) as! [String]
        if divArray.count > 0 {
            for objStr in divArray {
                if objStr.count > 0 && objStr.contains("class=\"networkImage-f-div\"") {
                    if objStr.contains("imgLoadError") {
                        htmlStr = htmlStr.replacingOccurrences(of: objStr, with: "")

                    }
                }
            }
        }
        return htmlStr
    }
        
    /// 将html转化为符合规则的array
    /// - Parameters:
    ///   - html: 编辑器生成的html
    ///   - cleanSpaces: 是否清理头尾的空格、换行
    /// - Returns: 符合后台规则的array
    static func creatHtmlDataArray(_ html: String, cleanSpaces: Bool) -> Array<Dictionary<String, Any>> {
        NSLog("贴子html内容: \(html)")

        var dataArr:[Dictionary<String, Any>] = []
        do {
            let doc: Document = try SwiftSoup.parse(html)
            let element = doc.body()
            for node in element!.getChildNodes() {
                NSLog("贴子Node内容:\(node)")
                let nodeStr = node.description
                if nodeStr.contains("networkImage") || nodeStr.contains("networkErrorImage") {// 添加图片
                    if node.getChildNodes().count > 0 {// 图片div中含有文字
                        dataArr = self.creatChildNodesContent(dataArr, node: node, cleanSpaces: cleanSpaces)
                    }else {
                        let imgDic = self.creatPostNetImgBy(node: node)
                        if imgDic.count > 2 {
                            dataArr.append(imgDic)
                        }
                    }
                }else if nodeStr.contains("linkCard-content-div"){
                    let nodeArr = node.getChildNodes()
                    if nodeArr.count > 0 {
                        // 外链卡片内容
                        let contentDic = self.creatPostCardBy(mainNode: nodeArr.first!)
                        // 卡片dic
                        var cardDic: Dictionary<String, Any> = [:]
                        cardDic["contentLink"] = contentDic
                        cardDic["contentType"] = "3"
                        dataArr.append(cardDic)
                    }

                }else {// 添加内容
                    var contentStr = ""
                    if node.getChildNodes().count > 0 {
                        for node1 in node.getChildNodes() {
                            let content = self.addPostContentBy(node: node1)
                            contentStr += content
                        }
                    }else if node.description.count > 0 {
                        let content = self.addPostContentBy(node: node)
                        contentStr += content
                    }

                    let contentDic = self.creatPostContentBy(content: contentStr, cleanSpaces: cleanSpaces)
                    if !contentDic.isEmpty {
                        dataArr.append(contentDic)
                    }
                }
            }
            
            let contentArr = self.cleanUpPostContentArr(contentArr: dataArr)
            NSLog("贴子内容: \(contentArr)")
            return contentArr
            
        } catch {
            NSLog("贴子内容: error")
            return []
        }
    }
    
    fileprivate static func creatChildNodesContent(_ dataArr:[Dictionary<String, Any>], node: Node, cleanSpaces: Bool) -> [Dictionary<String, Any>]{
        var dataArr = dataArr
        var contentStr = ""
        for node1 in node.getChildNodes() {
            NSLog("贴子Node1内容:\(node1)")
            
            if node1.getChildNodes().count > 0 {
                dataArr = creatChildNodesContent(dataArr, node: node1, cleanSpaces: cleanSpaces)
            }else {
                let node1Str = node1.description
                if node1Str.contains("networkImage") || node1Str.contains("networkErrorImage") {
                    // 添加图片前的文字
                    if contentStr.count > 0 {
                        let contentDic = self.creatPostContentBy(content: contentStr, cleanSpaces: cleanSpaces)
                        if !contentDic.isEmpty {
                            dataArr.append(contentDic)
                        }
                        contentStr = ""
                    }
                    
                    let imgDic = self.creatPostNetImgBy(node: node1)
                    if imgDic.count > 2 {
                        dataArr.append(imgDic)
                    }
                    
                }else {
                    let content = self.addPostContentBy(node: node1)
                    contentStr += content
                }
            }
        }
        // 添加文字
        if contentStr.count > 0 {
            let contentDic = self.creatPostContentBy(content: contentStr, cleanSpaces: cleanSpaces)
            if !contentDic.isEmpty {
                dataArr.append(contentDic)
            }
            contentStr = ""
        }
        return dataArr
        
    }
    
    fileprivate static func creatPostNetImgBy(node: Node) -> Dictionary<String, Any> {
        let nodeStr = node.description
        var dic: Dictionary<String, Any> = [:]
        if nodeStr.contains("networkImage") || nodeStr.contains("networkErrorImage") {
            dic["url"] = try? node.attr("src")
            dic["contentType"] = "2"
            let sizeStr = try? node.attr("alt")
            let sizeArr = sizeStr?.components(separatedBy: ",") ?? []
            if sizeArr.count > 1 {
                dic["imgWidth"] = sizeArr[0]
                dic["imgHeight"] = sizeArr[1]
                if sizeArr.count == 3 {// alt含有url
                    let urlStr = sizeArr[2]
                    if urlStr.count > 4 {
                        dic["url"] = urlStr
                    }else {// 没有url则为无效的dic
                        return ["":""]
                    }
                }
                if nodeStr.contains("networkErrorImage") {// 违禁图
                    dic["isAbnormal"] = "1"
                }
            }
        }
        return dic

    }
    
    fileprivate static func creatPostCardBy(mainNode: Node) -> Dictionary<String, Any>{
        var dic: Dictionary<String, Any> = [:]
        let nodeArr = mainNode.getChildNodes()
        if nodeArr.count > 0 {
            var isPost = false
            if mainNode.description.contains("linkCard-user-div") && nodeArr.count > 2 {//卡片含用户信息
                isPost = true
                let userNode = nodeArr.last
                let userArr = userNode?.getChildNodes() ?? []
                if userArr.count > 0 {
                    if userArr.count > 1 {
                        dic["nickName"] = self.creatNodeText(userArr.last)
                    }
                    dic["headUrl"] = try? userArr.first?.attr("src")
                    dic["postId"] = try? userNode?.attr("id")
                }
            }
            
            let urlNode = nodeArr[0]
            for node in urlNode.getChildNodes() {
                if node.description.contains("linkCard-iconImg") {// 链接图标
                    dic["iconUrl"] = try? node.attr("src")
                }else if node.description.contains("linkCard-content") {// 链接内容
                    let contentArr = node.getChildNodes()
                    if contentArr.count > 0 {
                        if contentArr.count > 2 {
                            if isPost {
                                dic["subTitle"] = self.creatNodeText(contentArr.last)
                            }else {
                                dic["url"] = self.creatNodeText(contentArr.last)
                            }
                            dic["title"] = self.creatNodeText(contentArr.first).trimmingCharacters(in: .whitespacesAndNewlines)

                        }else {// url 必存在
                            if isPost {
                                dic["title"] = self.creatNodeText(contentArr.first).trimmingCharacters(in: .whitespacesAndNewlines)
                            }else {
                                dic["url"] = self.creatNodeText(contentArr.first).trimmingCharacters(in: .whitespacesAndNewlines)
                            }
                        }
                    }
                }
                
            }
            
        }
        
        return dic
    }
    
    fileprivate static func creatNodeText(_ node: Node?) -> String {
        
        if let contentArr = node?.getChildNodes(), contentArr.count > 0 {
            return contentArr.first?.description ?? ""
        }
        return ""
    }
    
    fileprivate static func creatPostContentBy(content: String, cleanSpaces: Bool) -> Dictionary<String, Any> {
        var dic: Dictionary<String, Any> = [:]
        var contentStr = content

        if contentStr.contains("<br>") {
            contentStr = contentStr.replacingOccurrences(of: "<br>", with: "\n")
        }else if contentStr.isEmpty {
            contentStr = ""
        }
        
        contentStr = contentStr.replacingOccurrences(of: "&nbsp;", with: " ")
        contentStr = contentStr.replacingOccurrences(of: "<p>", with: "")
        contentStr = contentStr.replacingOccurrences(of: "</p>", with: "")
        contentStr = contentStr.replacingOccurrences(of: "<div>", with: "")
        contentStr = contentStr.replacingOccurrences(of: "</div>", with: "")

        if cleanSpaces {// 是否清理头尾空格、换行
            contentStr = contentStr.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        if contentStr.count > 0 {// 非空判断
            dic["content"] = contentStr
            dic["contentType"] = "1"
        }
        
        return dic
    }
    
    /// 根据node生成对应的内容
    fileprivate static func addPostContentBy(node: Node) -> String {
        var contentStr = ""
        
        let content = node.description
        if !content.isEmpty {
            if content.contains("localEmojiImage") {// 本地表情图
                let imgName = try? node.attr("alt")
                contentStr += self.creatLocalEmojiImageAlt(imgName ?? "")
                
            }else if content.contains("<span"){// 插入表情后会造成<span>的产生
                contentStr += node.getChildNodes()[0].description
            }else {
                contentStr += content
            }
        }
        return contentStr

    }
    
    
    ///  整理贴子内容数组，清除头尾的\n
    /// - Parameter contentArr: 贴子内容数组
    /// - Returns: 整理后的数组
    fileprivate static func cleanUpPostContentArr(contentArr: Array<Dictionary<String, Any>>) -> Array<Dictionary<String, Any>> {
        var dataArr = contentArr
        var arr = dataArr
        for dic in arr { // 正序删除多余的\n
            let contentType = dic["contentType"] as? String
            let content = (dic["content"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
            if (contentType == "1") && content?.count ?? 0 < 1 {
                dataArr.removeFirst()
            }else {
                break
            }
        }
        
        arr = dataArr
        var content = ""
        for dic in arr.reversed() { // 倒序删除多余的\n
            let contentType = dic["contentType"] as? String
            content = (dic["content"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            if (contentType == "1") && content.count < 1 {
                dataArr.removeLast()
            }else {
                break
            }
        }
        
        if content.count > 0 {
            dataArr[dataArr.count-1]["content"] = content
        }
        
        return dataArr
    }
    
    /// 根据贴子内容数组生成html
    /// - Parameters:
    ///   - list: 贴子内容数组
    ///   - isEdit: 是否可编辑，即图片是否有删除div
    /// - Returns: 生成的html
    static func creatPostHtmlBy(contentList list: [YXPostContentModel], isEdit: Bool = false ) -> String {
        var html = ""
        var isLastImg = false
        for model in list {
            if model.contentType == "1" {// 文本
                isLastImg = false
                var emojiArr:[YXEmojiItemModel] = []
                for group in YXEmojiDataManager.manager.emojiPackages {
                    emojiArr += group.emojis ?? []
                }
                
                var content = model.content ?? ""
                let imgArr = content.matchCustomEmoji()
                
                for imgStr in imgArr {
                    for model in emojiArr {
                        if imgStr == "_\(model.desc ?? "")" {
                            let html = YXCommonViewModel.creatLocationEmojiHtml(model.desc ?? "", imagePath: model.imagePath ?? "", isLargeEmoji: imgStr.isLargeEmoji())
                            content = content.replacingOccurrences(of: imgStr, with: html)
                        }
                    }
                }
                
                html += "<p>\(content)</p>"
            }else if model.contentType == "2" {// 图像
                if isEdit {
                    if isLastImg && !(html.hasSuffix("<p></p>")) {
                        html += "<p>\n</p>"
                    }
                    isLastImg = true

                    let imgKey = NSString.imageUUID()
                    if model.isAbnormal {// 违禁图
                        // div的左右边距为20
                        let height = Int(YXMainScreenWidth-40) * Int(model.imgHeight ?? "1")! / (Int(model.imgWidth ?? "1") ?? 1)
                        html += "<div class=\"networkErrorImage-f-div\" contenteditable=\"false\" id=\"\(imgKey)-img\" style=\"width:100%; height:\(height)px\"><img id=\"\(imgKey)-img\" class=\"networkErrorImage\" alt=\"\(model.imgWidth ?? "0"),\(model.imgHeight ?? "0")\" src=\"\(model.url ?? "")\"><img id=\"\(imgKey)-delImg\" src=\"post_delete.png\" class=\"networkImage-delete\"></div>"

                    }else {
                        // div的左右边距为20
                        
                        var imgHeight = Int(model.imgHeight ?? "1") ?? 1
                        var imgWidth = (Int(model.imgWidth ?? "1") ?? 1)
                        if imgWidth < 1 {
                            imgWidth = 10
                            imgHeight = 10
                        }
                        let height = Int(YXMainScreenWidth-40) * imgHeight / imgWidth
                        html += "<div class=\"networkImage-f-div\" contenteditable=\"false\" id=\"\(imgKey)-img\" style=\"width:100%; height:\(height)px\"><img id=\"\(imgKey)-img\" class=\"networkImage\" alt=\"\(model.imgWidth ?? "1"),\(model.imgHeight ?? "1"),\(model.url ?? "")\" src=\"\(model.url ?? "")\", onerror=\"this.src='base_edit_error_img.png'\"><img id=\"\(imgKey)-delImg\" src=\"post_delete.png\" class=\"networkImage-delete\"></div>"

                    }
                    
                }else {
                    html += "<img class='networkImage' src= '\(model.url ?? "")'>"
                }
            }else if model.contentType == "3" {// 外链卡片
                
                let cardKey = NSString.imageUUID()
                var cardModel = model.contentLink ?? YXPostLinkCardModel()
                cardModel.cardId = cardKey
                
                let cardHtml = YXCommonViewModel.creatLinkCardHtml(model: cardModel, isInsert: false)
                
                html += cardHtml
            }
        }
        if !isEdit {
            // 懒加载图片
            html = html.replacingOccurrences(of: "src", with: "data-original")
        }
//        NSLog("生成的html:\(html)")
        return html
    }
    
    
    /// 统计html所包含的数量数组，图片按照一个字符计算, 卡片按照一个字符计算
    /// - Parameter html: 所需统计的html
    /// - Returns: [titleNum, imgNum, cardNum]
    static func countHtmlTextImg(_ html: String) -> [Int] {
        do {
            var html = html
            var uploadingImgNum = 0
            if html.contains("reload-btn-txt") {
                html = html.replacingOccurrences(of: "[重新上传]", with: "")
                uploadingImgNum = 1
            }
            
            // 过滤卡片视图
            let divReg = "<div id=\"linkCard-content-div\"[^>]*>.*?</div></div>"
            let divArray = YXHtmlEditTool.match(html, toRegexString: divReg) as! [String]
            let cardNum = divArray.count
            if cardNum > 0 {
                for objStr in divArray {
                    html = html.replacingOccurrences(of: objStr, with: "")
                }
            }
            
            let doc: Document = try SwiftSoup.parse(html)
            let docText = try doc.text()
            let localImgs = try doc.getElementsByClass("localEmojiImage")
            let networkImgs = try doc.getElementsByClass("networkImage-f-div")
            let networkImgs1 = try doc.getElementsByClass("networkErrorImage-f-div")

            let titleNum = docText.count + localImgs.count
            let imgNum = networkImgs.count+networkImgs1.count + uploadingImgNum
            return [titleNum, imgNum, cardNum]
        }catch{
            return [0, 0]
        }
        
    }
    
    
    /// 根据大编辑框的html生成小编辑框的Text，不包含图片
    /// - Parameter html: 大编辑框的html
    /// - Returns: 小编辑框的text
    static func creatTextEditeHtmlData(_ html: String) -> String {
        var textStr = ""
        do {
            let doc: Document = try SwiftSoup.parse(html)
            let element = doc.body()
            for node in element!.getChildNodes() {
                var contentStr = ""
                if node.getChildNodes().count > 0 {
                    for node1 in node.getChildNodes() {
                        let content = node1.description
                        if !content.isEmpty {
                            if content.contains("localEmojiImage") {// 本地表情图
                                let imgName = try node1.attr("alt")
                                contentStr += self.creatLocalEmojiImageAlt(imgName)
                            }else if content.contains("<span"){// 插入表情后会造成<span>的产生
                                contentStr += node1.getChildNodes()[0].description
                            }else {
                                contentStr += content
                            }
                        }
                    }
                }else if node.description.count > 0 {
                    let content = node.description
                    if !content.isEmpty {
                        if content.contains("localEmojiImage") {// 本地表情图
                            let imgName = try node.attr("alt")
                            contentStr += self.creatLocalEmojiImageAlt(imgName)
                        }else if content.contains("<span"){// 插入表情后会造成<span>的产生
                            contentStr += node.getChildNodes()[0].description
                        }else {
                            contentStr += content
                        }
                    }
                }
                
                if contentStr.contains("<br>") {
                    contentStr = contentStr.replacingOccurrences(of: "<br>", with: "\n")
                }else if contentStr.isEmpty {
                    contentStr = "\n"
                }
                if contentStr.contains("&nbsp;") {
                    contentStr = contentStr.replacingOccurrences(of: "&nbsp;", with: " ")
                }
                
                textStr.append(contentStr)
            }
            
            textStr = textStr.trimmingCharacters(in: .whitespacesAndNewlines)
            NSLog("编辑框内容: \(textStr)")
            return textStr
            
        } catch {
            NSLog("编辑框内容: error")
            return textStr
        }
    }
    
    
    /// 根据小编辑框的Text生成大编辑框的html，可包含自定义表情包
    /// - Parameter text: 小编辑框的html
    /// - Returns: 大编辑框的html
    static func creatHtmlEditeTextData(_ text: String) -> String {
        var content = text.replacingOccurrences(of: "\n", with: "<br>")
        
        var emojiArr:[YXEmojiItemModel] = []
        for group in YXEmojiDataManager.manager.emojiPackages {
            emojiArr += group.emojis ?? []
        }
        let imgArr = content.matchCustomEmoji()
        
        for imgStr in imgArr {
            for model in emojiArr {
                if imgStr == "_\(model.desc ?? "")" {
                    
                    let html = YXCommonViewModel.creatLocationEmojiHtml(model.desc ?? "", imagePath: model.imagePath ?? "", isLargeEmoji: imgStr.isLargeEmoji())
                    // 将自定义表情替换为本地图
                    content = content.replacingOccurrences(of: imgStr, with: html)
                }
            }
        }
        return content
    }
    
    
    /// 生成本地表情包的alt
    /// - Parameter html: 本地表情包的html
    /// - Returns: 本地表情包的alt
    static func creatLocalEmojiImageAlt(_ html: String) -> String {
        /** 小框变为大编辑框后,网络图删除时，会生成脏数据alt包含整个表情包img
         <img class="localEmojiImage" height="30" width="30" alt="<img class='localEmojiImage' alt='alt-[/呲牙]' src='file:///Users/zhangchaoyang/Library/Developer/CoreSimulator/Devices/249BA98A-D809-48AB-AE3E-1D3A22D66C58/data/Containers/Bundle/Application/25A2F7E1-7E7C-4A72-B8DF-810B042D30BD/HeroGameBox.app/EmojiPackage.bundle/Item01/001.png'/>" src="file:///Users/zhangchaoyang/Library/Developer/CoreSimulator/Devices/249BA98A-D809-48AB-AE3E-1D3A22D66C58/data/Containers/Bundle/Application/25A2F7E1-7E7C-4A72-B8DF-810B042D30BD/HeroGameBox.app/EmojiPackage.bundle/Item01/001.png">
         */
        
        // 修复本地图展示后alt从_[/流泪]变为alt-[/流泪]
        var imgName = html.replacingOccurrences(of: "alt-", with: "_")
        // FIXME: 需优化
        if imgName.contains("localEmojiImage") {// 数据异常处理
            let imgArr = imgName.matchCustomEmoji()
            if imgArr.count > 0 {
                imgName = imgArr[0]
            }
        }
        return imgName
    }
    
    /// 生成本地的表情包HTML
    /// - Parameters:
    ///   - desc: 表情包名
    ///   - imagePath: 表情包url
    /// - Returns: 表情包HTML
    static func creatLocationEmojiHtml(_ desc: String, imagePath: String, isLargeEmoji: Bool) -> String {
        var html = ""
        if isLargeEmoji {
            let imagePath = imagePath.replacingOccurrences(of: ".png", with: "@3x.png")
            html = "<img class='localEmojiImage' height = '60' width = '60' alt='alt-\(desc)' src='file://\(imagePath)'/>"
        }else {
            html = "<img class='localEmojiImage' height = '30' width = '30' alt='alt-\(desc)' src='file://\(imagePath)'/>"
        }
        return html
    }
    
    
    /// 生成外链卡片的HTML
    /// - Parameter model: 外链卡片的Model
    /// - Returns: 外链卡片的HTML
    static func creatLinkCardHtml(model: YXPostLinkCardModel, isInsert: Bool = true) -> String {
        var lineH = ""
        var contentStr = ""
        
        if model.postId?.count ?? 0 > 0 {// 贴子链接
            if model.subTitle?.count ?? 0 > 0 {//
                lineH = "30px"
                contentStr = "<font id='linkCard-title'>\(model.title ?? "")</font>" + "<br>" + "<font id='linkCard-subTitle'>\(model.subTitle ?? "")</font>"
            }else {
                lineH = "60px"
                contentStr = "<font id='linkCard-title'>\(model.title ?? "")</font>"
            }
        }else {
            if model.title?.count ?? 0 > 0 {//
                lineH = "30px"
                contentStr = "<font id='linkCard-title'>\(model.title ?? "")</font>" + "<br>" + "<font id='linkCard-subTitle'>\(model.url ?? "")</font>"
            }else {
                lineH = "60px"
                contentStr = "<font id='linkCard-subTitle'>\(model.url ?? "")</font>"
            }
        }
        
        var userInfoHtml = ""
        if model.postId?.count ?? 0 > 0 {
            userInfoHtml = "<div id='linkCard-line' class='linkCard-line' ></div>"
            + "<div class='linkCard-user-div' id = '\(model.postId ?? "")'>"
            + "<img class='linkCard-headerImg' src='\(model.headUrl ?? "")'/>"
            + "<font id='linkCard-nickname' class='linkCard-nickname'>\(model.nickName ?? "")</font>"
            + "</div>";
        }
        
        let cardHtml = "<div id='linkCard-content-div' class='linkCard-content-div' contenteditable='false'><div class='linkCard-f-div' contenteditable='false' id = '\(model.cardId ?? "")-card'>"
        + "<div class='linkCard-main-div'  id = '\(model.cardId ?? "")-card-main'>"
        + "<img class='linkCard-iconImg' src='\(model.iconUrl ?? "")'/>"
        + "<div class='linkCard-content' style='line-height: \(lineH)'>\(contentStr)</div>"
        + "<img class='linkCard-delete' id = '\(model.cardId ?? "")-delImg' src='post_delete.png' />"
        + "</div>"
        + userInfoHtml
        + "</div>"
        + "</div>";
        
        if isInsert {
            return "<br>\(cardHtml)<br>"
        }else {
            return cardHtml
        }

    }
    
}


// MARK: 字符串处理

extension YXCommonViewModel {
    
    /// 将头像进行压缩后的展示
    /// - Parameters:
    ///   - headImgV: 头像
    ///   - url: 头像url
    
    
    /// 根据等级获取相应的等级图标
    /// - Parameter level: 用户等级
    /// - Returns: 等级图标
    static func userLevelTagName(_ level: String) -> String {
        let levelCount = Int(level) ?? 0
        var imageStr = "level_icon_1-5"
        if levelCount <= 5 {
            imageStr = "level_icon_1-5"
        }else if levelCount <= 10 {
            imageStr = "level_icon_6-10"
        }else if levelCount <= 15 {
            imageStr = "level_icon_11-15"
        }else if levelCount <= 25 {
            imageStr = "level_icon_16-25"
        }else if levelCount <= 40 {
            imageStr = "level_icon_26-40"
        }else if levelCount <= 55 {
            imageStr = "level_icon_41-55"
        }else if levelCount <= 70 {
            imageStr = "level_icon_56-70"
        }else if levelCount <= 85 {
            imageStr = "level_icon_71-85"
        }else if levelCount <= 100 {
            imageStr = "level_icon_86-100"
        }else {
            imageStr = "level_icon_86-100"
        }
        return imageStr
    }

}
