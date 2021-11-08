//
//  YXNormalEditBaseController.swift
//  HeroGameBox
//
//  Created by zcy on 2020/12/17.
//

import UIKit
import SwiftSoup
import IQKeyboardManagerSwift
import MBProgressHUD

enum YXPostEditOriginStyle {
    /// 来自tabbar主入口
    case noraml
    /// 来自讨论区入口
    case forum
    /// 来自话题详情入口
    case topic
    
}

class YXNormalEditBaseController: YXBaseWithNavigationBarViewController, WKNavigationDelegate, WKUIDelegate {
    
    /// 贴子编辑成功回调
    var postEditFinishBlock:(() -> Void)?
    
    /// 编辑的上一层
    var originStyle: YXPostEditOriginStyle = .noraml
    
    let YXEditHeaderViewH: CGFloat = 100
    
    let viewModel = YXNormalEditBaseViewModel()
    // 当前游戏的gameId
    let gameId: String = ""
    let uploadImageManager = YXUploadImagesManager()
    
    var testNum = 1
    
    lazy var myWebView: YXEditWebView = {
        
        let webView = YXEditWebView()
        webView.scrollView.alwaysBounceVertical = true
        webView.scrollView.alwaysBounceHorizontal = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.backgroundColor = .clear
        webView.isOpaque = false
        //        webView.setStyleDark(isDark: true)
        let baseURL = URL(fileURLWithPath: Bundle.main.bundlePath)
        let htmlPath = Bundle.main.path(forResource: "richText_editor", ofType: "html")
        var htmlCont = try? String(contentsOfFile: htmlPath!, encoding: .utf8)
        webView.loadHTMLString(htmlCont!, baseURL: baseURL)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        webView.keyboardDisplayRequiresUserAction = false
        return webView
    }()
    
    lazy var headerView: YXEditHeaderView = {
        let headerView = YXEditHeaderView(frame: CGRect(x: 0, y: 0, width: YXMainScreenWidth, height: YXEditHeaderViewH))
        
        return headerView
    }()
    
    lazy var linkBgView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(hexString: "0x000000")
        view.alpha = 0.29
        return view
    }()

    convenience init(originStyle: YXPostEditOriginStyle, gameId: String, forumModel: YXGameForumModel, topicList: [YXTopicsModel]) {
        self.init()
        
        self.originStyle = originStyle
        
//        self.headerView.configUI(gameId: gameId, forumModel: forumModel, topicList: topicList)
        
    }
    
}


// MARK: - Life Cycle

extension YXNormalEditBaseController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 是否编辑贴子
//        if let forumModel: YXGameForumModel = self.viewModel.setupEditPostMethod() {
//            self.headerView.isPostEdit = true
//            self.headerView.configUI(self.viewModel.detailModel?.postTitle ?? "", gameId: self.viewModel.detailModel?.gameId ?? "", forumModel: forumModel, topicList: self.viewModel.detailModel?.topics ?? [])
//        }
        
        // 监控粘贴事件，并删除粘贴内容的格式
        self.myWebView.setupListenerPaste()
    }
    
}

// MARK: - UIOverride

extension YXNormalEditBaseController {
    
    override func loadMainView() {
        super.loadMainView()
        
        view.addSubview(self.myWebView)
        
        self.myWebView.frame = CGRect(x: 0, y: CGFloat(YXNavBarHight), width: YXMainScreenWidth, height: YXMainScreenHeight - YXNavBarHight)
        self.myWebView.headerView = self.headerView
        
    }
    
    override func loadNavigationBar() {
        super.loadNavigationBar()
        
        navTitleLabel.text = "发布贴子"
        navView.addSubview(navRightPublishBtn)
        navRightPublishBtn.frame = CGRect(x: YXMainScreenWidth - 60 - 16, y: YXStatusBarHight+6, width: 60, height: 32)
    }
    
    override func navBackBtnAction() {
        if !self.viewModel.isPostEdit {// 非已发布贴子的编辑，保存草稿
            let str = self.headerView.titleTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            self.viewModel.savePostDraftMethod(titleStr: str)
        }
        super.navBackBtnAction()
    }
    
    // MARK: 设置回调
    override func addBlock() {
        
        // 键盘配件触发事件
        self.myWebView.accessoryView.clickEditItemBlock = {[weak self] (editorBar, item) in
            self?.clickEditItemMethod(editorBar, item: item)
        }
        
        // 插入外链
        self.myWebView.linkAccessoryView.clickItemBlock = {[weak self] (item) in
            if item == 1 {// 插入
                self?.insertLinkCardMethod()
            }else {// 取消
                self?.closeLinkCardMethod()
            }
        }
        
        
        self.headerView.monitorTitleTextChangeBlock = {[weak self] in
            self?.monitorRightNavBtn()
        }
        
        self.viewModel.contentHtmlTextHandler = { [weak self] (titleStr) in
            
            self?.myWebView.contentHtmlTextHandler { (result) in
                if var html = result as? String {
                    // 重置图片异常html
                    html = YXCommonViewModel.resetImageErrorHtml(html)
                    YXPostDraftManager.saveNormalPostDraft(title: titleStr, contentStr: html)
                }
            }
        }
        
        self.uploadImageManager.webViewInsertImageClosure = { [weak self] (fileM) in
            
            // 1、网络请求本地占位图
            self?.myWebView.insertImage(fileM.imageData!, key: fileM.key!)
            
        }
        
        self.uploadImageManager.webViewInsertImageKeyClosure = { [weak self] (fileM, progress) in
            // 2、模拟网络请求上传图片 更新进度
            self?.myWebView.insertImageKey(fileM.key!, progress: progress)
        }
        
        self.uploadImageManager.webViewInsertImageSuccessClosure = { [weak self] (key, imgUrl, size) in
            // div的左右间距为20
            let div_h = CGFloat((self?.myWebView.width ?? 40) - 40) * size.height / size.width
            self?.myWebView.insertSuccessImageKey(key, imgUrl: imgUrl, img_size: size, div_h: div_h)
        }
        
        /// 开始上传 回调
        self.uploadImageManager.uploadPhotoBeginClosure = { [weak self]  in
            if !isiOS11System() {// 当前为iOS11系统
                self?.view.endEditing(true)
            }
            self?.myWebView.insertHTML("<br><br>")
        }
        
        /// 上传完成 回调
        self.uploadImageManager.uploadPhotoFinishClosure = { [weak self] (isEdit) in
            
            self?.myWebView.setupEditEnable(isEdit)
            self?.myWebView.getCaretYPositionHandler({[weak self] (result) in
                if let num = result as? Int {
                    self?.myWebView.autoScrollTop(CGFloat(num))
                }
            })
        }
    }
}


// MARK: - Method

// MARK: 监控统计内容
extension YXNormalEditBaseController {
    
    /// 监控发布按钮是否可点击
    func monitorRightNavBtn() {
        
        let titleStr = self.headerView.titleTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        // 当版块、标题、内容不为空时方可发布贴子
        if titleStr.count < 1 || (self.viewModel.textLength < 1 && self.viewModel.networkImgsNum < 1 && self.viewModel.cardNum < 1) || self.viewModel.textLength > self.viewModel.WordsLimitNum {
            self.navRightPublishBtn.isEnabled = false
            self.navRightPublishBtn.backgroundColor = UIColor(hexString: "0xDFDEE4")
        }else {
            self.navRightPublishBtn.isEnabled = true
            self.navRightPublishBtn.backgroundColor = UIColor(hexString: "0x6668F0")
        }
    }
    
    /// 更新内容统计字数
    func setupPostContentNum(_ htmlStr: String) {
        let numArr = YXCommonViewModel.countHtmlTextImg(htmlStr)
        // 统计文字数量，包括本地表情包
        self.viewModel.textLength = numArr[0]
        // 统计网络图
        self.viewModel.networkImgsNum = numArr[1]
        // 统计链接卡片
        self.viewModel.cardNum = numArr[2]

        if self.viewModel.textLength > self.viewModel.WordsLimitNum {
            let numStr = "\(self.viewModel.textLength)/\(self.viewModel.WordsLimitNum)"
            let attr = NSMutableAttributedString(string: numStr)
            let range = numStr.range(of: "\(self.viewModel.textLength)")
            attr.setAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], range: NSRange(range!, in: numStr))
            self.myWebView.accessoryView.counterNumLab.attributedText = attr
        }else {
            self.myWebView.accessoryView.counterNumLab.text = "\(self.viewModel.textLength)/\(self.viewModel.WordsLimitNum)"
        }
        if (self.viewModel.textLength + self.viewModel.networkImgsNum + self.viewModel.cardNum) < 1 {
            // 为空时避免存在换行符
            self.myWebView.setupContent("")
            self.myWebView.showContentPlaceholder()
        }else {
            self.myWebView.clearContentPlaceholder()
        }
    }
    
}

// MARK: - 贴子草稿

extension YXNormalEditBaseController {
    
    /// 显示草稿箱的内容
    func showPostDraftMethod() {
        let draftModel = YXPostDraftManager.getPostDraftModel(style: .normalStyle)
        if draftModel.postTitle?.count ?? 0 > 0 || draftModel.contentStr?.count ?? 0 > 0 {
            
            let clickLeftBtnBlock: (()-> Void) = {// 重新写
                YXPostDraftManager.removePostDraftModel(.normalStyle)
            }
            
            let clickRightBtnBlock: (()-> Void) = {[weak self] in // 恢复草稿
                self?.headerView.setupTitle(draftModel.postTitle ?? "")
                
                let contentStr = draftModel.contentStr ?? ""
                if contentStr.count > 0 {// 如果有内容
                    // 初始化内容
                    self?.myWebView.setupYXContent("\(contentStr)")
                    self?.myWebView.clearContentPlaceholder()
                    // 为网络大图添加删除事件
                    self?.setupShowHtmlEvent(contentStr)
                    // 更新内容字数
                    self?.setupPostContentNum(contentStr)
                    self?.monitorRightNavBtn()
                }
            }
            
//            let alertModel = YXAlertModel(style: .judgementContentAlert, title: "", rightBtnTitle: "恢复", leftBtnTitle: "重新写", contentString: "您还有未发布的内容已自动保存，是否恢复？",clickLeftBtnBlock: clickLeftBtnBlock, clickRightBtnBlock: clickRightBtnBlock)
//            let context: [AnyHashable : Any] = ["model" : alertModel]
//
//
//            navigator.open(RouterPath.openBaseAlertPage.rawValue, context: context)
        }
    }
    
    // 为所显示的网络大图配置响应事件
    func setupShowHtmlEvent(_ htmlStr: String){
        
        if !htmlStr.contains("networkImage") && !htmlStr.contains("linkCard-f-div") {
            return
        }
        
        do {
            let doc: Document = try SwiftSoup.parse(htmlStr)
            let delets = try doc.getElementsByClass("networkImage-delete")
            for elems in delets {
                // 200200FB-41BB-4E7D-A596-83D9CC7DC05E-delImg
                let idStr = try elems.attr("id")
                let imgId = idStr.replacingOccurrences(of: "-delImg", with: "")
                self.myWebView.addImgEventKey(imgId)
            }
                        
            let delets1 = try doc.getElementsByClass("linkCard-delete")
            for elems in delets1 {
                // 200200FB-41BB-4E7D-A596-83D9CC7DC05E-delImg
                let idStr = try elems.attr("id")
                let cardId = idStr.replacingOccurrences(of: "-delImg", with: "")
                self.myWebView.addCardEventKey(cardId)
            }
            
        }catch{
        }
    }
    
}

// MARK: - 编辑贴子
extension YXNormalEditBaseController {
    
    /// 开始编辑贴子
    func startEditPostMethod() {
        // 适配编辑
        var contentStr = "\(self.viewModel.postEditHtml)<br>"
        if contentStr.hasPrefix("<div class=\"networkImage-f-div\"") || contentStr.hasPrefix("<div class=\"networkErrorImage-f-div\""){
            contentStr = "<br>" + contentStr
        }
        contentStr = contentStr.replacingOccurrences(of: "<p>", with: "")
        contentStr = contentStr.replacingOccurrences(of: "</p>", with: "")
        contentStr = contentStr.replacingOccurrences(of: "\n", with: "<br>")
        
        // 初始化内容
        self.myWebView.setupYXContent("\(contentStr)")
        self.myWebView.clearContentPlaceholder()
        // 添加删除事件
        self.setupShowHtmlEvent(contentStr)
        // 刷新内容
        self.myWebView.focusTextEditor()
        // 更新贴子内容数
        setupPostContentNum(contentStr)
        monitorRightNavBtn()
    }
}

// MARK: - 点击键盘编辑项
extension YXNormalEditBaseController {
    
    func clickEditItemMethod(_ editorBar: YXHtmlEditorBar, item: Int) {
        switch item {
        case 0:
            // 收键盘
            self.view.endEditing(false)
            break
        case 1:
            // 表情
            if self.myWebView.showEmojiKeyboard {
                self.myWebView.showEmojiKeyboard = false
                editorBar.emojiBtn.setImage(UIImage(named: "post_comment_icon_emoji"), for: .normal)
            }else {
                self.myWebView.showEmojiKeyboard = true
                editorBar.emojiBtn.setImage(UIImage(named: "post_comment_icon_keyborad"), for: .normal)
            }
            
            // 调用WKContentView
            let inputView = self.myWebView.subviews[0].subviews[0]
            inputView.reloadInputViews()
            
            break
        case 2:
            
            // 插入图片
            self.addPhotoPickerMethod()
            break
        case 3:
            // 链接
            self.addHyperLinkMethod()
            break
        default:
            break
        }
    }
        
    // MARK: 选择上传图片
    func addPhotoPickerMethod() {
        
        self.myWebView.contentHtmlTextHandler {[weak self] (result) in
            if let htmlStr = result as? String {
                let numArr = YXCommonViewModel.countHtmlTextImg(htmlStr)
                self?.viewModel.networkImgsNum = numArr[1]

                var num = (self?.viewModel.netImgsLimitNum ?? 0) - numArr[1]
                if num <= 0 {
                    num = 0
                }
                
                let imgPickerVC = YXImagePickerController()
                imgPickerVC.maxImagesCount = num > 9 ? 9:num
                imgPickerVC.selectPhotosFinishClosure = {[weak self] (_ photos: [YXUploadImageModel]) in
                    if photos.count > 0 {
                        self?.startUploadPhotoMethod(photos)
                    }
                }
                self?.present(imgPickerVC, animated: true, completion: nil)
            }
        }
    }
    
    /// 开始上传图片
    /// - Parameters:
    ///   - photos: 上传的图片
    ///   - isAppend: 是否是追加上传 0 非追加  1 追加
    func startUploadPhotoMethod(_ photos: [YXUploadImageModel], isAppend: Bool = false) {
        // 判断非追加上传，处理webview
        if isAppend == false {
            if !isiOS11System() {// 当前为iOS11系统
                self.view.endEditing(true)
            }
            self.myWebView.insertHTML("<br><br>")
        }
        
        var uploadPics: [YXHtmlUploadPictureModel] = []
        for _ in photos {
            let fileM = YXHtmlUploadPictureModel()
            let img = UIImage(named: "base_default_img.png")
            fileM.imageData = img!.pngData()
            fileM.key = NSString.imageUUID()
            uploadPics.append(fileM)
            
            // 判断非追加上传，处理webview
            if isAppend == false {
                // 1、网络请求本地占位图
                self.myWebView.insertImage(fileM.imageData!, key: fileM.key!)
            }else {
                self.myWebView.appendImage(fileM.imageData!, key: fileM.key!)
            }
           
            // 2、模拟网络请求上传图片 更新进度
            self.myWebView.insertImageKey(fileM.key!, progress: 0.3)
        }
        let hud = MBProgressHUD.showAddHud()
        
        // 模拟网络请求
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            hud.hide(animated: true, afterDelay: 0.3)
            
            let imgUrls = ["","","","","","","",""]
            let uploadPicArr = uploadPics
            for i in 0..<uploadPicArr.count {
                
                let model: YXUploadImageModel = photos[i]
                
                let fileM = uploadPicArr[i]
                let imgUrl = imgUrls[i]
                let imgSize = model.image?.size ?? CGSize(width: 10, height: 10)
                self.myWebView.insertImageKey(fileM.key!, progress: 1.0)
                // div的左右间距为20
                let div_h = CGFloat((self.myWebView.width) - 40) * imgSize.height / imgSize.width
                self.myWebView.insertSuccessImageKey(fileM.key ?? "", imgUrl: imgUrl, img_size: imgSize, div_h: div_h)
            }
            
            self.myWebView.setupEditEnable(true)
            self.myWebView.getCaretYPositionHandler({[weak self] (result) in
                if let num = result as? Int {
                    self?.myWebView.autoScrollTop(CGFloat(num))
                }
            })
            
        }
    }
    
    // MARK: 添加链接
    
    /// 设置外链卡片入口
    func addHyperLinkMethod() {
        

        if self.myWebView.accessoryViewStyle == .link {
            self.myWebView.accessoryViewStyle = .normal
            self.linkBgView.removeFromSuperview()
        }else {
            self.myWebView.accessoryViewStyle = .link
            UIApplication.shared.keyWindow?.addSubview(self.linkBgView)
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                self.myWebView.linkAccessoryView.linkTF.becomeFirstResponder()
            }
            self.myWebView.linkAccessoryView.resetQuickView()
        }
        // 调用WKContentView
        let inputView = self.myWebView.subviews[0].subviews[0]
        inputView.reloadInputViews()
    }
    
    ///  插入外链卡片
    func insertLinkCardMethod() {

        let link = self.myWebView.linkAccessoryView.linkTF.text ?? ""
        if link.count < 4 {
            MBProgressHUD.showText("请输入正确的链接")
            return
        }
        let titleStr = self.myWebView.linkAccessoryView.titleTF.text ?? ""
        
//        viewModel.requestServerParseLink(link) {[weak self] finish, model in
//            if finish {
//
//                // 清空链接
//                self?.myWebView.linkAccessoryView.linkTF.text = ""
//                self?.myWebView.linkAccessoryView.titleTF.text = ""
//
//                var cardModel: YXPostLinkCardModel
//                let cordKey = NSString.imageUUID()
//                if model?.postId?.count ?? 0 > 0 {// 贴子链接
//                    cardModel = YXPostLinkCardModel(url: link, title: model?.postTitle ?? "", subTitle: model?.postContent ?? "", iconUrl: model?.iconUrl ?? "", headUrl: model?.userHeadUrl ?? "", nickName: model?.nickName ?? "", postId: model?.postId ?? "", cardId: cordKey)
//
//                }else {// 外部链接
//                    cardModel = YXPostLinkCardModel(url: link, title: titleStr, iconUrl: model?.iconUrl ?? "", cardId: cordKey)
//                }
//                let cardHtml = YXCommonViewModel.creatLinkCardHtml(model: cardModel)
//                self?.myWebView.insertLinkCardKey(cordKey, cardHtml: cardHtml)
//                self?.closeLinkCardMethod()
//            }
//        }
    }
    
    // 关闭外链卡片入口
    func closeLinkCardMethod() {
        // 清空链接
        self.myWebView.linkAccessoryView.linkTF.text = ""
        self.myWebView.linkAccessoryView.titleTF.text = ""
        
        self.myWebView.accessoryViewStyle = .normal
        self.linkBgView.removeFromSuperview()
        self.myWebView.becomeFirstResponder()
        // 调用WKContentView
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
            let inputView = self.myWebView.subviews[0].subviews[0]
            inputView.reloadInputViews()
        }
    }
    
}


// MARK: - 拦截图片&卡片点击
extension YXNormalEditBaseController {
    
    func handleWebViewImage(_ urlStr: String){
        let preStr = "protocol://iOS?code=uploadResult&data="
        if urlStr.hasPrefix(preStr) {
            //            self.view.endEditing(true)
            let dic = self.makeDictionary(urlStr, preStr: preStr)
            if dic["imgId"] as! String != "YXClickImgAction" {// 点击删除按钮
                //例如删除图片执行函数imgID=key;
                self.myWebView.deleteImageKey(dic["imgId"] as! String)
                // 刷新内容
                self.myWebView.load(URLRequest(url: URL(string: "re-state-content://")!))
            }else {
                self.myWebView.setupEditEnable(true)
            }
        }else {
            self.myWebView.setupEditEnable(true)
        }
    }
    
    func handleWebViewCard(_ urlStr: String){
        let preStr = "protocol://iOS?code=deleteCard&data="
        if urlStr.hasPrefix(preStr) {
            let dic = self.makeDictionary(urlStr, preStr: preStr)
            if let cardId = dic["cardId"] as? String {// 点击删除按钮
                //删除外链卡片
                self.myWebView.deleteLinkCardKey(cardId)
                // 刷新内容
                self.myWebView.load(URLRequest(url: URL(string: "re-state-content://")!))
            }else {
                self.myWebView.setupEditEnable(true)
            }
        }else {
            self.myWebView.setupEditEnable(true)
        }
    }
    
    func makeDictionary(_ resultUrl: String, preStr: String) -> Dictionary<String, Any> {
        let result = resultUrl.replacingOccurrences(of: preStr, with: " ")
        let jsonStr = result.removingPercentEncoding
        let jsonData = jsonStr?.data(using: .utf8)
        do {
            let dic = try JSONSerialization.jsonObject(with: jsonData ?? Data(), options: .mutableContainers)
            return dic as! Dictionary<String, Any>
        } catch {
            return [:]
        }
    }
    
}


// MARK: - 发布

extension YXNormalEditBaseController {
    
    // 点击发布
    override func navPublishPostBtnAction(sender: UIButton) {
        
        sender.avoidRepeatMethod()
        self.myWebView.contentHtmlTextHandler { (result) in
            if var htmlStr = result as? String {
                
                if htmlStr.contains("imgLoadError") {// 图片上传异常
                    MBProgressHUD.showText("请删除异常图片，再发布")
                    //                }else if htmlStr.contains("base_edit_error_img.png") {// 违禁图
                    //                    MBProgressHUD.showText("请删除异常图片，再发布")
                }else {
                    // 整理html
                    htmlStr = YXCommonViewModel.creatResetHtml(htmlStr)
                    // 开始发布请求
                    self.requestServerPostPublishMethod(htmlStr)
                }
            }
        }
    }
    
    /// 开始发布贴子请求
    private func requestServerPostPublishMethod(_ html: String) {
        
        let htmlStr = "<p>\(html)</p>"
        
        // 内容arr
        let contentArr = YXCommonViewModel.creatHtmlDataArray(htmlStr, cleanSpaces: false)
        
        if contentArr.count <= 0 {
            MBProgressHUD.showText("内容不能为空")
            return
        }
        
        // 话题list
        var topicStr = ""
//        for topic in self.headerView.topicList {
//            topicStr += topic.topicId! + ","
//        }
        if topicStr.count > 0 {// 话题可为空
            topicStr.removeLast()
        }
        /// 结束编辑状态
        self.view.endEditing(true)
        
        // FIXME: 测试，超出10000字数后内容丢失
        
        let titleStr = self.headerView.titleTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        let hud = MBProgressHUD.showAddHud()
        
//        viewModel.requestServerPostPublish(contentArr, gameForumId: "\(self.headerView.forumModel?.id ?? "")", gameId: self.headerView.gameId, postTitle: titleStr, postType: "1", topics: topicStr, postId: self.viewModel.postId) {[weak self] (finished, postID) in
//            hud.hide(animated: true)
//            if finished {// 请求结束后切换到首页进入到详情页面
//
//                if self?.viewModel.postId.count ?? 0 > 0 {// 贴子编辑成功
//                    self?.postEditFinishBlock?()
//                    self?.postEditFinishMethod(self?.viewModel.postId ?? "")
//                }else {// 贴子发布成功
//                    self?.postPushFinishMethod(postID ?? "", originStyle: self?.originStyle ?? .noraml)
                    // 清空草稿箱
//                    YXPostDraftManager.saveNormalPostDraft(title: "", contentStr: "")
//                }
//            }
//        }
    }
}

// MARK: - Delegate
// MARK: WKWebViewDelegate
extension YXNormalEditBaseController {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    
        let urlStr = navigationAction.request.url?.absoluteString
//        NSLog("urlStr==========\(urlStr)")
        
        if urlStr?.contains("touchCallback") ?? false {
            decisionHandler(.cancel)
        }else if urlStr?.range(of: "re-state-content://") != nil {
            let className = urlStr?.replacingOccurrences(of: "re-state-content://", with: "")
            //            NSLog("decidePolicyFor：re-state-content")
            self.myWebView.contentHtmlTextHandler {[weak self] (result) in
                if let htmlStr = result as? String {
                    NSLog("htmlStr:\(htmlStr)")
                    /// 统计字数
                    self?.setupPostContentNum(htmlStr)
                    /// 监控发送按钮是否可点击
                    self?.monitorRightNavBtn()
                    
                }
            }
            if ((className?.components(separatedBy: ",").contains("unorderedList")) != nil) {
                self.myWebView.clearContentPlaceholder()
            }
            self.myWebView.setupEditEnable(true)
            
            decisionHandler(.cancel)
        }else if urlStr?.range(of: "protocol://iOS?code=uploadResult") != nil {
            //            NSLog("decidePolicyFor：re-state-Image")
            self.handleWebViewImage(urlStr ?? "")
            decisionHandler(.cancel)
        }else if urlStr?.range(of: "protocol://iOS?code=deleteCard") != nil {
            self.handleWebViewCard(urlStr ?? "")
            decisionHandler(.cancel)

        }else {
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.myWebView.addHeaderViewForWebView(webView)
        
        if self.viewModel.isPostEdit {
            startEditPostMethod()
        }else {
            // 展示草稿箱弹窗
            showPostDraftMethod()
        }
        
    }
    
}


// MARK: UIScrollViewDelegate
extension YXNormalEditBaseController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // FIXME: 解决标题上滑bug,后续需优化
//        if self.headerView.isfocusTitleTF {
//            scrollView.contentOffset = CGPoint(x: 0, y: 0)
//        }else {
//            scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
//        }
    }
}
