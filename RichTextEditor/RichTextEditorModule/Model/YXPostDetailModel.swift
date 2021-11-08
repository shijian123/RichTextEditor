//
//  YXPostDetailModel.swift
//  HeroGameBox
//
//  Created by zcy on 2020/12/22.
//

import UIKit


struct YXPostDetailModel {
    /// 浏览量
    var browseCount: String?
    /// 评论量
    var commentCount: String?
    /// 头像url
    var headCodeUrl: String?
    /// 用户等级
    var userLevel: String?
    /// 贴子id
    var id: String?
    /// 贴子是否被锁定
    var isLock: Bool = false
    /// 最后编辑时间
    var lastEditorTime: String?
    /// 点赞量
    var likeCount: String?
    /// 是否已点赞
    var isLike: Bool?
    /// 收藏量
    var collectionCount: String?
    /// 是否已收藏
    var isCollect: Bool?
    /// 贴子封面
    var postCover: String?
    /// 帖子发布时间
    var postTime: String?
    /// 贴子标题
    var postTitle: String?
    /// 用户名
    var userName: String?
    /// 发帖人的id
    var postUserId: String?
    /// 用户标识url
    var identificationUrl: String?
    /// 贴子内容list
    var postContent: [YXPostContentModel]?
    /// 是否关注，0：未关注，1：已关注，2：互相关注
    var isFollow: String?
    /// 是否为精贴
    var isElite: Bool?
    /// 是否为官方贴
    var isOfficial: Bool?
    /// 是否有热门评论，需手动赋值
    var isHotCount: Bool?
    /// 游戏版块id
    var gameForumId: String?
    /// 游戏版块
    var gameForumVo: YXGameForumModel?
    /// 游戏id
    var gameId: String?
    /// 游戏名
    var gameName: String?
    /// 帖子类型 1 帖子 2图片
    var postType: String?
    /// 是否为发帖者
    var isMine: Bool?
}

struct YXPostContentModel {
    /// 内容
    var content: String?
    /// 内容样式：1、文本；2、图片
    var contentType: String?
    /// 图像的高
    var imgHeight: String?
    /// 图像的宽
    var imgWidth: String?
    /// 图像是否为封面
    var isCover: String?
    /// 图片的url
    var url: String?
    /// 图片是否异常
    var isAbnormal: Bool = false
    
    // 链接卡片内容
    var contentLink: YXPostLinkCardModel?

}

struct YXPostLinkCardModel {
    /// 链接
    var url: String?
    /// 标题
    var title: String?
    /// 副标题
    var subTitle: String?
    /// 图标
    var iconUrl: String?
    /// 头像
    var headUrl: String?
    /// 昵称
    var nickName: String?
    
    /// 贴子Id
    var postId: String?
    
    /// 链接卡片id， 自定义属性
    var cardId: String?
}

struct YXParseLinkModel {
    /// 贴子Id
    var postId: String?
    /// 图标
    var iconUrl: String?
    /// 1 内链 2 外链
    var linkTye: String?
    /// 贴子标题
    var postTitle: String?
    /// 贴子内容
    var postContent: String?
    /// 用户头像
    var userHeadUrl: String?
    /// 用户昵称
    var nickName: String?

}

extension YXPostDetailModel {
    
    func getPostContent() -> String {
        var contentStr = ""
        if self.postContent?.count ?? 0 > 0 {
            let model = self.postContent?[0]
            if model?.contentType == "2" {
                contentStr = "【图片】"
            }else {
                contentStr = model?.content ?? ""
            }
        }
        
        return contentStr
    }
}
