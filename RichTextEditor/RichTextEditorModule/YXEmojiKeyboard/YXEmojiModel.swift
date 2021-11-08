//
//  YXEmojiModel.swift
//  HeroGameBox
//
//  Created by zcy on 2020/12/28.
//

import UIKit

/// 表情类型
enum YXEmojiType: Int {
    /// 本地表情
    case local = 1
    /// 我的表情
    case myExpression = 2
}

class YXEmojiItemModel {
    var desc: String?
    var imageName: String?
    var folderName: String?
    var image: UIImage?
    var imagePath: String?
    var isLargeEmoji: Bool?
    /// FIXME: 缺少动态图
//    var gifImage: SDAnimatedImage
    
    init(_ dict: [String: Any]? = nil) {
        if let dict = dict {
            self.imageName = dict["image"] as? String
            self.desc = dict["desc"] as? String
        }
    }
}

class YXEmojiGroupModel {
    var cover_pic: String?
    var coverImage: UIImage?
    var folderName: String?
    var title: String?
    var isLargeEmoji: Bool?
    var emojis: [YXEmojiItemModel]?
    var type: YXEmojiType
    var customModels = [Any]()
    
    init(_ dict: [String: Any]) {
        self.type = YXEmojiType(rawValue: (dict["type"] as? Int) ?? 1) ?? .local
        self.cover_pic = dict["cover_pic"] as? String
        self.title = dict["title"] as? String
        self.folderName = dict["folderName"] as? String
        self.isLargeEmoji = dict["isLargeEmoji"] as? Bool
        var arrM: [YXEmojiItemModel] = []
        let emojiBundlePath = Bundle.main.path(forResource: "EmojiPackage", ofType: "bundle") ?? ""
        let sourcePath = Bundle(path: emojiBundlePath)?.path(forResource: dict["folderName"] as? String, ofType: nil) ?? ""
        if let emojis = dict["emojis"] as? [Dictionary<String, Any>] {
            for i in 0..<emojis.count {
                let emojiDict = emojis[i]
                let emoji = YXEmojiItemModel()
                let imagePath = sourcePath+"/\(emojiDict["image"] ?? "")"
                emoji.imageName = emojiDict["image"] as? String
                emoji.desc = emojiDict["desc"] as? String
                emoji.imagePath = imagePath
                emoji.folderName = self.folderName
                emoji.isLargeEmoji = self.isLargeEmoji
                emoji.image = UIImage(contentsOfFile: imagePath)
                arrM.append(emoji)
            }
        }
        self.emojis = arrM
    }
}

