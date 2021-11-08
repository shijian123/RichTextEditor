//
//  YXEditWebView.swift
//  HeroGameBox
//
//  Created by zcy on 2020/12/17.
//

import UIKit
import WebKit

enum YXAccessoryViewStyle {
    case normal
    case comment
    case link
}

class YXEditWebView: WKWebView {
    
    var webView: WKWebView?
    var headerView: UIView?
    var footerView: UIView?
    var alreadyShowHeader = false
    var showEmojiKeyboard = false
    /// 编辑框的样式
    var accessoryViewStyle: YXAccessoryViewStyle = .normal
    
    /// 可输入的最大的表情（仅限-评论编辑框）
    var EmojiMAXNum = 10
    
    lazy var accessoryView: YXHtmlEditorBar = {
        let view = YXHtmlEditorBar.loadFromNib()!
        return view
    }()
    
    lazy var commentAccessoryView: YXCommentEditorBar = {
        let view = YXCommentEditorBar.loadFromNib()!
        return view
    }()
    
    
    lazy var linkAccessoryView: YXHtmlEditorLinkBar = {
        let view = YXHtmlEditorLinkBar.loadFromNib()!
        return view
    }()
    
    lazy var emojiInputView: YXEmojiInputView = {
        let inputV = YXEmojiInputView(frame: CGRect(x: 0, y: 0, width: YXMainScreenWidth, height: 270+YXScreenBottomH))
        inputV.clickEmojiItemBlock = {[weak self] (model) in
            self?.contentHtmlTextHandler {[weak self] (result) in
                if let htmlStr = result as? String {
                    let imgArr = YXHtmlEditTool.match(htmlStr, toRegexString: "localEmojiImage") as! [String]
                    if (self?.accessoryViewStyle == .comment) && (imgArr.count >= self?.EmojiMAXNum ?? 10) {// 仅在评论编辑框的监控
                        MBProgressHUD.showText("最多只能插入10个表情哦")
                    }else {
                        let html = YXCommonViewModel.creatLocationEmojiHtml(model.desc ?? "", imagePath: model.imagePath ?? "", isLargeEmoji: model.isLargeEmoji ?? false)
                        self?.insertHTML(html)
                        NSLog("insertHTML")
                    }
                }
            }
        }
        inputV.clickDeleteEmojiBlock = {[weak self] in
            // 调用WKContentView
            let inputView = self?.subviews[0].subviews[0] as? UITextInput
            inputView?.deleteBackward()
        }
        return inputV
    }()
    
    /// 在代理方法 (webView: didStartProvisionalNavigation:) 优先中调用
    func setupHeaderViewForWebView(_ webView: WKWebView) {
        if headerView != nil {
            if alreadyShowHeader {
                return
            }else {
                //                alreadyShowHeader = true
            }
            
        }
    }
    /// 在代理方法 (webView: didFinishNavigation:) 优先中调用
    func addHeaderViewForWebView(_ webView: WKWebView) {
        if headerView != nil {
            if alreadyShowHeader {
                return
            }else {
                webView.scrollView.addSubview(headerView!)
                alreadyShowHeader = true
            }
        }
    }
    
    /// 重写键盘附件
    override var inputAccessoryView: UIView? {
        
        if self.accessoryViewStyle == .comment {
            return self.commentAccessoryView
        }else if self.accessoryViewStyle == .link {
//            self.linkAccessoryView.linkTF.becomeFirstResponder()
            return self.linkAccessoryView
        }else {
            return self.accessoryView
        }
    }
    
    /// 重写键盘内容
    override var inputView: UIView? {
        if self.showEmojiKeyboard {
            return self.emojiInputView
        }else {
            return nil
        }
    }
    
    /// 重写键盘附件：iOS11方法替换
    @objc var inputAccessoryView_ios11: UIView? {
        
        if let editView = self.superview?.superview as? YXEditWebView {
            if editView.accessoryViewStyle == .comment {
                return editView.commentAccessoryView
            }else if editView.accessoryViewStyle == .link {
                return editView.linkAccessoryView
            }else {
                return editView.accessoryView
            }
        }else {
            return nil
        }
        
    }
    
    /// 重写键盘内容：iOS11方法替换
    @objc var inputView_ios11: UIView? {
        if let editView = self.superview?.superview as? YXEditWebView {
            if editView.showEmojiKeyboard {
                return editView.emojiInputView
            }
        }
        return nil
    }
    
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        if isiOS11System() {// 当前为iOS11系统
            DispatchQueue.once {
                self.hack_editInputAccessory()
            }
        }
        
        /// iOS15适配drag and drop
        if #available(iOS 15.0, *) {
            addDropForbiddenMethod()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension YXEditWebView {
    @objc var darkKeyboardAppearanceTemplateMethod: UIKeyboardAppearance {
        return .dark
    }
    
    @objc var lightKeyboardAppearanceTemplateMethod: UIKeyboardAppearance {
        return .light
    }
    
    func setStyleDark (isDark: Bool = true) {
        var candidateView: UIView? = nil
        for view in self.scrollView.subviews {
            if String(describing: type(of: view)).hasPrefix("WKContent") {
                candidateView = view
            }
        }
        guard let targetView = candidateView else {
            return
        }
        
        var method: Method!
        if isDark {
            method = class_getInstanceMethod(YXEditWebView.self, #selector(getter: darkKeyboardAppearanceTemplateMethod))
        } else {
            method = class_getInstanceMethod(YXEditWebView.self, #selector(getter: lightKeyboardAppearanceTemplateMethod))
        }
        let imp = method_getImplementation(method!)
        let typeEncoding = method_getTypeEncoding(method!)
        class_replaceMethod(targetView.superclass, #selector(getter: UITextInputTraits.keyboardAppearance), imp, typeEncoding)
    }
}



typealias OlderClosureType =  @convention(c) (Any, Selector, UnsafeRawPointer, Bool, Bool, Any?) -> Void
typealias NewerClosureType =  @convention(c) (Any, Selector, UnsafeRawPointer, Bool, Bool, Bool, Any?) -> Void

extension YXEditWebView{
    
    var keyboardDisplayRequiresUserAction: Bool? {
        get {
            return self.keyboardDisplayRequiresUserAction
        }
        set {
            self.setKeyboardRequiresUserInteraction(newValue ?? true)
        }
    }
    
    func setKeyboardRequiresUserInteraction( _ value: Bool) {
        
        guard
            let WKContentViewClass: AnyClass = NSClassFromString("WKContentView") else {
            print("Cannot find the WKContentView class")
            return
        }
        
        let olderSelector: Selector = sel_getUid("_startAssistingNode:userIsInteracting:blurPreviousNode:userObject:")
        let newerSelector: Selector = sel_getUid("_startAssistingNode:userIsInteracting:blurPreviousNode:changingActivityState:userObject:")
        
        if let method = class_getInstanceMethod(WKContentViewClass, olderSelector) {
            
            let originalImp: IMP = method_getImplementation(method)
            let original: OlderClosureType = unsafeBitCast(originalImp, to: OlderClosureType.self)
            let block : @convention(block) (Any, UnsafeRawPointer, Bool, Bool, Any?) -> Void = { (me, arg0, arg1, arg2, arg3) in
                original(me, olderSelector, arg0, !value, arg2, arg3)
            }
            let imp: IMP = imp_implementationWithBlock(block)
            method_setImplementation(method, imp)
        }
        
        if let method = class_getInstanceMethod(WKContentViewClass, newerSelector) {
            
            let originalImp: IMP = method_getImplementation(method)
            let original: NewerClosureType = unsafeBitCast(originalImp, to: NewerClosureType.self)
            let block : @convention(block) (Any, UnsafeRawPointer, Bool, Bool, Bool, Any?) -> Void = { (me, arg0, arg1, arg2, arg3, arg4) in
                original(me, newerSelector, arg0, !value, arg2, arg3, arg4)
            }
            let imp: IMP = imp_implementationWithBlock(block)
            method_setImplementation(method, imp)
        }
        
    }
    
}

extension YXEditWebView {
    
    /// 适配iOS11的键盘配件
    func hack_editInputAccessory() {
        
        guard let target = scrollView.subviews.first(where: {
            String(describing: type(of: $0)).hasPrefix("WKContent")
        }), let _ = target.superclass else {
            return
        }

        let originalClass: AnyClass = object_getClass(target) ?? NSObject.self
        let swizzledClass: AnyClass = YXEditWebView.self
        
        YXEditWebView.swizzlingForClass(originalClass, originalSelector: #selector(getter: target.inputAccessoryView), swizzledClass: swizzledClass, swizzledSelector: #selector(getter: YXEditWebView.inputAccessoryView_ios11))
        
        YXEditWebView.swizzlingForClass(originalClass, originalSelector: #selector(getter: target.inputView), swizzledClass: swizzledClass, swizzledSelector: #selector(getter: YXEditWebView.inputView_ios11))

    }
    
    static func swizzlingForClass(_ originalClass: AnyClass, originalSelector: Selector, swizzledClass: AnyClass, swizzledSelector: Selector) {
        let originalMethod = class_getInstanceMethod(originalClass, originalSelector)
        let swizzledMethod = class_getInstanceMethod(swizzledClass, swizzledSelector)
        guard (originalMethod != nil && swizzledMethod != nil) else {
            return
        }
        if class_addMethod(originalClass, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!)) {
                class_replaceMethod(swizzledClass, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
            } else {
                method_exchangeImplementations(originalMethod!, swizzledMethod!)
            }
    }
    
}


// MARK: UIDropInteraction

@available(iOS 11.0, *) extension YXEditWebView: UIDropInteractionDelegate {
    
    func addDropForbiddenMethod() {
        guard let target = scrollView.subviews.first(where: {
            String(describing: type(of: $0)).hasPrefix("WKContent")
        }), let _ = target.superclass else {
            return
        }
        if target.subviews.count > 0 {
            target.subviews[0].addInteraction(UIDropInteraction(delegate: self))
        }
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return true
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .forbidden)
    }
}
