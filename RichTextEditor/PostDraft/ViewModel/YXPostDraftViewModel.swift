//
//  YXPostDraftViewModel.swift
//  HeroGameBox
//
//  Created by zcy on 2021/4/23.
//

import UIKit
import SwiftyUserDefaults

enum YXPostDraftStyle {
    case normalStyle
    case imageStyle
    case allStyle
}

class YXPostDraftViewModel: NSObject {
   
    
}

class YXPostDraftManager: NSObject {
    
    // 获取贴子草稿
    var YXGetNormalPostDraft: DefaultsKey<Dictionary<String, Any>> { .init("YXGetNormalPostDraft", defaultValue: [:]) }
    var YXGetImagePostDraft: DefaultsKey<Dictionary<String, Any>> { .init("YXGetImagePostDraft", defaultValue: [:]) }
    
    /// 保存图文贴子草稿
    static func saveNormalPostDraft(title: String, contentStr: String){
        
        let postDic = [
            "title": title,
            "contentStr": contentStr,
        ] as [String : Any]
        
//        Defaults[\.YXGetNormalPostDraft] = postDic
    }
    
    /// 保存图片贴子草稿
    static func saveImagePostDraft(title: String, contentStr: String, list: [Dictionary<String, Any>]){
        
        let postDic = [
            "title": title,
            "contentStr": contentStr,
            "imageList": list
        ] as [String : Any]
        
//        Defaults[\.YXGetImagePostDraft] = postDic
    }
    
    
    /// 获取贴子草稿
    static func getPostDraftModel(style: YXPostDraftStyle) -> YXPostDraftModel {
        
        var postDic: Dictionary<String, Any> = [:]
        if style == .normalStyle {
//            postDic = Defaults[\.YXGetNormalPostDraft]
        }else if style == .imageStyle {
//            postDic = Defaults[\.YXGetImagePostDraft]
        }
        
        var postDraftM = YXPostDraftModel()
        postDraftM.postTitle = postDic["title"] as? String
        postDraftM.contentStr = postDic["contentStr"] as? String
        postDraftM.imageList = postDic["imageList"] as? [Dictionary<String, Any>] ?? []
        
        return postDraftM
    }
    
    /// 删除贴子草稿
    static func removePostDraftModel(_ style: YXPostDraftStyle) {
        
//        if style == .normalStyle {
//            Defaults[\.YXGetNormalPostDraft] = [:]
//        }else if style == .imageStyle {
//            Defaults[\.YXGetImagePostDraft] = [:]
//        }else if style == .allStyle {
//            Defaults[\.YXGetNormalPostDraft] = [:]
//            Defaults[\.YXGetImagePostDraft] = [:]
//        }
    }
}
