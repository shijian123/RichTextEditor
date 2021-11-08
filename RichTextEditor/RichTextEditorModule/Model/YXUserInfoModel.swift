//
//  YXUserInfoModel.swift
//  HeroGameBox
//
//  Created by zcy on 2020/12/7.
//

import UIKit

class YXGameForumModel: NSObject {
    /// 论坛名
    var name: String?
    /// 论坛id
    var id: String?
    /// 版块类型，1：贴子；2：图片
    var forumType: String?
    /// 版块UI类型，1：讨论区，2：攻略，3：同人
    /// 交流区，含话题、筛选、置顶
    /// 攻略，含banner、话题、筛选、置顶
    /// 同人，含同人榜、话题、筛选、置顶
    var forumUiType: String?
    /// 数据类型，1：全部 2：推荐  3：版块
    var forumDataType: String?
    /// 图片url
    var iconUrl: String?
    /// 浅色模式的图片
    var iconWhiteUrl: String?
    /// 是否为官方版块
    var isOfficial: Bool?

    
    required override init() {
    }
    
}
