//
//  YXRichTextModel.swift
//  RichTextEditor
//
//  Created by zcy on 2021/11/3.
//

import Foundation

class YXTopicsModel: NSObject, NSCoding {
    /// 话题id
    var topicId: String?
    /// 话题名
    var topicName: String?
    /// 话题简介
    var topicDesc: String?
    /// 话题iconUrl
    var topicIconUrl: String?
    /// 所属的模块
    var gameForumId: String?
    /// 所属的游戏id
    var gameId: String?
    /// 所属的游戏名字
    var gameName: String?

    /// 是否关注
    var isFollow = false
    
    /// 是否选中，自定义属性
    var isSelected = false
    /// 话题的宽度，自定义属性
    var topicWidth: CGFloat = 0.0
    /// 是否可以删除，自定义属性
    var isCanDelete = false

    /// 自定义匹配搜索关键词数组
    var keyWordArr: [String] = []
    /// 自定义话题UI类型
//    var uiStyle: YXTopicsCellStyle = .normal

    required override init() {}
    
    func encode(with coder: NSCoder) {
        coder.encode(topicId, forKey: "topicId")
        coder.encode(topicName, forKey: "topicName")
        coder.encode(topicDesc, forKey: "topicDesc")
        coder.encode(topicIconUrl, forKey: "topicIconUrl")
        coder.encode(gameForumId, forKey: "gameForumId")
        coder.encode(gameId, forKey: "gameId")
    }
    
    required init?(coder: NSCoder) {
        super.init()
        topicId = coder.decodeObject(forKey: "topicId") as? String
        topicName = coder.decodeObject(forKey: "topicName") as? String
        topicDesc = coder.decodeObject(forKey: "topicDesc") as? String
        topicIconUrl = coder.decodeObject(forKey: "topicIconUrl") as? String
        gameForumId = coder.decodeObject(forKey: "gameForumId") as? String
        gameId = coder.decodeObject(forKey: "gameId") as? String
        
    }
}


enum UploadType {
    case image
    case gifImage
}

struct YXUploadImageModel {
    var data: Data?
    var type: UploadType?
    var image: UIImage?
}
