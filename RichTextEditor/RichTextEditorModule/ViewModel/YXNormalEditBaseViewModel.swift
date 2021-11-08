//
//  YXNormalEditBaseViewModel.swift
//  HeroGameBox
//
//  Created by zcy on 2021/1/4.
//

import UIKit

class YXNormalEditBaseViewModel: NSObject {
    
    // 返回带标签的html格式的文本内容
    var contentHtmlTextHandler: ((String) -> Void)?
    

    var emojiKeyboard: YXEmojiInputView?
    /// 最多输入的字符数，自定义表情包1个字
    let WordsLimitNum = 10000
    /// 当前文本的字数，包括本地表情包
    var textLength = 0
    /// 最多添加网络图量
    let netImgsLimitNum = 50
    /// 当前选择的网络图量
    var networkImgsNum = 0
    /// 当前插入的链接卡片量
    var cardNum = 0
    /// 编辑贴子html
    var postEditHtml = ""
    /// 编辑贴子的id
    var postId = ""
    /// 是否为贴子编辑
    var isPostEdit = false
    /// 贴子详情Model
    var detailModel: YXPostDetailModel?
    
}


extension YXNormalEditBaseViewModel {
    
    /// 设置编辑贴子
    /// - Parameter model: 贴子详情
    func setupEditPostMethod() -> YXGameForumModel? {
        
        // 是否编辑贴子
        if self.detailModel == nil { return nil}
        
        self.isPostEdit = true
        
        let html = YXCommonViewModel.creatPostHtmlBy(contentList: detailModel?.postContent ?? [], isEdit: true)
        
        let forumModel = YXGameForumModel()
        forumModel.id = detailModel?.gameForumId
        forumModel.name = detailModel?.gameForumVo?.name
        forumModel.iconUrl = detailModel?.gameForumVo?.iconUrl
        forumModel.iconWhiteUrl = detailModel?.gameForumVo?.iconWhiteUrl

        self.postEditHtml = html
        self.postId = detailModel?.id ?? ""
        
        return forumModel
        
    }
    
    /// 保存草稿
    func savePostDraftMethod(titleStr: String) {
        
        let titleStr = titleStr
        
        if (self.networkImgsNum + self.textLength + self.cardNum) > 0 {// 贴子有内容
            self.contentHtmlTextHandler?(titleStr)
        }else {
//            YXPostDraftManager.saveNormalPostDraft(title: titleStr, contentStr: "")
        }
    }

}

// MARK: - request

extension YXNormalEditBaseViewModel {
    
    /// 贴子发布
    /// - Parameters:
    ///   - content: 贴子内容
    ///   - gameForumId: 游戏版块id
    ///   - gameId: 游戏id
    ///   - postTitle: 贴子标题
    ///   - postType: 贴子类型：1、贴子；2、图片
    ///   - topics: 话题id逗号隔开（非必传）
    ///   - postId: 贴子编辑时的贴子id
    ///   - completion: 请求成功回调
    func requestServerPostPublish(_ content: Array<Any>, gameForumId: String, gameId: String, postTitle: String, postType: String, topics: String, postId: String = "", completion: @escaping (_ finish: Bool, _ postID:String?) -> Void) {
//        var params: [String: Any] = [
//            "content": content.toJsonString(),
//            "gameForumId": gameForumId,
//            "gameId": gameId,
//            "postTitle": postTitle,
//            "postType": postType,
//            //            "topics": topics,
//        ]
//        
//        if topics.count > 0 {
//            params["topics"] = topics
//        }
//        
//        // FIXME: 编辑贴子接口待联调
//        if postId.count > 0 {// 贴子编辑
//            params["postId"] = postId
//            YXNetManager.shareInstance.post(urlString: "\(YXNetInfo.apiPostEdit)", parameters: YXNetInfo.formParamSignature(params)) { (jsonDic, error) in
//                
//                let code = jsonDic["code"] as? Int
//                let data = jsonDic["data"] as? Dictionary<String, Any>
//                if code == YXNetInfo.code200 {
//                    completion(true, data?["postId"] as? String)
//                }else {
//                    completion(false, "")
//                }
//            }
//        }else {// 贴子发布
//            YXNetManager.shareInstance.post(urlString: "\(YXNetInfo.apiPostPublish)", parameters: YXNetInfo.formParamSignature(params)) { (jsonDic, error) in
//                
//                let code = jsonDic["code"] as? Int
//                let data = jsonDic["data"] as? Dictionary<String, Any>
//                if code == YXNetInfo.code200 {
//                    completion(true, data?["postId"] as? String)
//                }else {
//                    completion(false, "")
//                }
//            }
//        }
    }
    
    /// 解析链接
    /// - Parameters:
    ///   - link: 待解析链接
    func requestServerParseLink(_ link:String, completion: @escaping (_ finish: Bool, _ model: YXParseLinkModel?) -> Void) {
                
        let params: [String: Any] = [
            "link": link
        ]
        
//        let hud = MBProgressHUD.showAddHud()
//
//        YXNetManager.shareInstance.post(urlString: "\(YXNetInfo.apiParseLinkt)", parameters: YXNetInfo.formParamSignature(params)) { (jsonDic, error) in
//
//            hud.hide(animated: true)
//
//            let code = jsonDic["code"] as? Int
//            let data = jsonDic["data"] as? Dictionary<String, Any>
//            if code == YXNetInfo.code200 {
//
//                let linkModel = YXParseLinkModel.deserialize(from: data)
//
//                completion(true, linkModel)
//            }else {
//                completion(false, nil)
//            }
//        }
    }
}
