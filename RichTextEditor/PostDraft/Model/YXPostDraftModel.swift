//
//  YXPostDraftModel.swift
//  HeroGameBox
//
//  Created by zcy on 2021/4/23.
//

import UIKit

struct YXPostDraftModel {

    /// 贴子标题
    var postTitle: String?
    /// 贴子内容
    var contentStr: String?
    /// 图片贴子，图片地址List
    var imageList: [Dictionary<String, Any>] = []
    
}
