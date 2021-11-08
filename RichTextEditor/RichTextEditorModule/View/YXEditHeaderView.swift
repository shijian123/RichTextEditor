//
//  YXEditHeaderView.swift
//  HeroGameBox
//
//  Created by zcy on 2020/12/17.
//

import UIKit
import IQKeyboardManagerSwift

class YXEditHeaderView: UIView, UITextFieldDelegate {
    
    // 标题输入
    lazy var titleV: UIView = {
        let titleV = UIView(frame: CGRect(x: 0, y: 0, width: self.width, height: 50))
        titleV.backgroundColor = UIColor.colorWith(lightColor: "0xffffff", darkColor: "0x2b2b2b")

        return titleV
    }()
    lazy var titleTF: UITextField = {
        let titleTF = UITextField(frame: CGRect(x: 20, y: 0, width: titleV.width-100, height: titleV.height))
        titleTF.tag = 1000
        titleTF.delegate = self
        titleTF.placeholder = "请输入标题（必填）"
        titleTF.textColor = .black
        titleTF.clearButtonMode = .never
        return titleTF
    }()
    lazy var numLab: UILabel = {
        let numLab = UILabel(frame: CGRect(x: titleV.width-70, y: 0, width: 50, height: titleV.height))
        numLab.font = .systemFont(ofSize: 14)
        numLab.textAlignment = .right
        numLab.text = "0/\(WordsLimitNum)"
        numLab.textColor = .gray
        return numLab
    }()
    lazy var lineV1: UIImageView = {
        let lineV1 = UIImageView(frame: CGRect(x: 16, y: 49, width: titleV.width - 32, height: 1))
        lineV1.backgroundColor = .gray
        return lineV1
    }()
    
    
    var monitorTitleTextChangeBlock:(() -> Void)?

    /// 是否贴子编辑
    var isPostEdit = false
    /// 是否为图片发帖
    var isImageEdit = false
    
    /// 标题输入框是否为焦点
    var isfocusTitleTF = false
    
    let WordsLimitNum = 30
    /// 所属的控制器
    var rootVC: YXBaseController?
    /// 选择版块所属的游戏，发帖时需要gameId，同时版块只选择当前游戏的
    var gameId: String = ""
    /// 选择的版块
//    var forumModel: YXGameForumModel?
    /// 选择的话题
//    var topicList: [YXTopicsModel] = []
    
    /// 设置所属的控制器
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var inputAccessoryView: UIView? {
        return nil
    }
    
}


// MARK: 设置UI

extension YXEditHeaderView {
    func setupUI() {
//        addSubview(self.topView)
//        addSubview(self.tagView)
//        tagView.addSubview(self.titleLab)
//        tagView.addSubview(self.topicPlaceholderLab)
//        tagView.addSubview(self.rightImgV)
//        tagView.addSubview(self.lineV2)
//        let btn = UIButton(type: .custom)
//        btn.frame = tagView.bounds
//        btn.addTarget(self, action: #selector(selectTopicsMethod), for: .touchUpInside)
//        tagView.addSubview(btn)
//        tagView.addSubview(self.topicView)
//
        addSubview(self.titleV)
        titleV.addSubview(self.titleTF)
        titleV.addSubview(self.numLab)
        titleV.addSubview(self.lineV1)
        
//        configUI()
    }
    
    
    func configUI(_ title: String = "") {
        if title.count > 0 {
            self.setupTitle(title)
        }
//        self.resetupUI(gameId: gameId, forumModel: forumModel, topicList: topicList)
    }
}


// MARK: Method

extension YXEditHeaderView {
    
    /// 版块选择， 判断是否已经选择了版块&数据的同步
    @objc func selectTopicsMethod() {
        
//        let vc = YXSelectTopicController()
//        vc.selectedList = self.topicList
//        vc.isImageEdit = self.isImageEdit
//        vc.isPostEdit = self.isPostEdit
//        vc.gameId = self.gameId
//        vc.saveTopicDataBlock = {[weak self] (gameId, forumModel, topicList) in
//
//            self?.resetupUI(gameId: gameId, forumModel: forumModel, topicList: topicList ?? [])
//
//            self?.monitorTopicChangeBlock?()
//        }
//
//
//        let nav = YXBaseNavController(rootViewController: vc)
//        nav.modalPresentationStyle = .fullScreen
//        if forumModel == nil {
//
//            let context: [AnyHashable : Any] = [
//                "isImageEdit" : self.isImageEdit,
//                "gameId": self.gameId
//            ]
//            navigator.push(RouterPath.openSelectForumPage.rawValue, context: context, from: nav)
//
//        }else {
//            vc.forumModel = forumModel
//        }
        
//        self.clickselectTopicsBlock?(nav)
    }
    
    
    ///  重置header的话题UI
    /// - Parameters:
    ///   - gameModel: 游戏Model
    ///   - forumModel:版块Model
    ///   - topicList: 话题list
//    func resetupUI(gameId: String, forumModel: YXGameForumModel, topicList: [YXTopicsModel]) {
//        self.gameId = gameId
//        self.forumModel = forumModel
//        self.topicList = topicList
//        self.topicView.forumModel = forumModel
//        self.topicView.reloadData(list: topicList)
//
//        self.topicView.isHidden = self.forumModel == nil
//        self.topicPlaceholderLab.isHidden = self.forumModel != nil
//    }
    
    /// 设置标题
    func setupTitle(_ title: String) {
        self.titleTF.text = title
        self.setupTitleCount()
    }
    
    /// 更新标题统计字数
    func setupTitleCount() {
        
        let textStr = self.titleTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)

        if let toBeString = textStr {
            if toBeString.count > WordsLimitNum {
//                MBProgressHUD.showText("标题最多设置\(WordsLimitNum)个字哦")
                let str1 = toBeString.substring(to: WordsLimitNum)
                self.titleTF.text = str1.trimmingCharacters(in: .whitespacesAndNewlines)
                self.numLab.text = "\(titleTF.text!.count)/\(WordsLimitNum)"
            }else{
                self.numLab.text = "\(textStr!.count)/\(WordsLimitNum)"
            }
        }
    }
    
}

// MARK: Delegate

extension YXEditHeaderView {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.isfocusTitleTF = true
        /// 更新统计字数
        self.setupTitleCount()
        /// 更新标题修改block
        self.monitorTitleTextChangeBlock?()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if #available(iOS 13, *) {
        }else {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                self.isfocusTitleTF = true
                /// 更新统计字数
                self.setupTitleCount()
                /// 更新标题修改block
                self.monitorTitleTextChangeBlock?()
            }
        }        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let textStr = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.numLab.text = "\(textStr!.count)/\(WordsLimitNum)"
        self.monitorTitleTextChangeBlock?()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.isfocusTitleTF = true
//        IQKeyboardManager.shared.enableAutoToolbar = true

    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.isfocusTitleTF = false
        return true
    }
}

// MARK: - 深浅模式
extension YXEditHeaderView {
//    func configUI() {
//        self.tagView.backgroundColor = .clear
//        self.titleV.backgroundColor = .clear
//        self.topicPlaceholderLab.textColor = UIColor.colorWith(lightColor: "0xCCCCCC", darkColor: "0x979AA2")
//        self.titleLab.textColor = UIColor.colorWith(lightColor: "0x141414", darkColor: "0xDDDDDD")
//        self.titleTF.textColor = UIColor.colorWith(lightColor: "0x000000", darkColor: "0xDDDDDD")
//        self.numLab.textColor = UIColor.colorWith(lightColor: "0xcccccc", darkColor: "0x979AA2")
//        self.lineV1.backgroundColor = DefaulCellBottomLineColor
//        self.lineV2.backgroundColor = DefaulCellBottomLineColor
//    }
}
