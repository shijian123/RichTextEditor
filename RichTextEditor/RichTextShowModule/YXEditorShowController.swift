//
//  YXEditorShowController.swift
//  RichTextEditor
//
//  Created by zcy on 2021/11/3.
//

import UIKit

class YXEditorShowController: UIViewController {

    var contentArr:Array<Dictionary<String, Any>> = []
    var postContent: [YXPostContentModel]? = []

    var longPressAction: YXTextAction?
    
    lazy var mainScrollV: UIScrollView = {
        let scrollV = UIScrollView(frame: self.view.bounds)
        scrollV.addSubview(contentLabel)
        return scrollV
    }()
    
    lazy var contentLabel: YYLabel = {
        let lab = YYLabel(frame: CGRect(x: 16, y: 0, width: YXMainScreenWidth-32, height: 20))
        return lab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "详情"
        view.addSubview(mainScrollV)
        view.backgroundColor = .white
        
        // 设置贴子内容
        setupContentMethod()
    }

    
    /// 更新贴子内容
    func setupContentMethod() {
        
        self.postContent = []
        
        for itemDic in self.contentArr {
            let content = itemDic["content"] as? String ?? ""
            let contentType = itemDic["contentType"] as? String ?? ""
            let imgHeight = itemDic["imgHeight"] as? String ?? ""
            let imgWidth = itemDic["imgWidth"] as? String ?? ""
            let isCover = itemDic["isCover"] as? String ?? ""
            let url = itemDic["url"] as? String ?? ""

            if let contentLink = itemDic["contentLink"] as? Dictionary<String, Any> {
                let url = contentLink["url"] as? String ?? ""
                let title = contentLink["title"] as? String ?? ""
                let subTitle = contentLink["subTitle"] as? String ?? ""
                let iconUrl = contentLink["iconUrl"] as? String ?? ""

                let cardModel = YXPostLinkCardModel(url: url, title: title, subTitle: subTitle, iconUrl: iconUrl, headUrl: "", nickName: "", postId: "", cardId: "")
                
                let model = YXPostContentModel(content: content, contentType: contentType, imgHeight: imgHeight, imgWidth: imgWidth, isCover: isCover, url: url, isAbnormal: false, contentLink: cardModel)
                self.postContent?.append(model)
            }else {
                let model = YXPostContentModel(content: content, contentType: contentType, imgHeight: imgHeight, imgWidth: imgWidth, isCover: isCover, url: url, isAbnormal: false)
                self.postContent?.append(model)
            }

        }
        
        contentLabel.numberOfLines = 0
        contentLabel.clearContentsBeforeAsynchronouslyDisplay = true
        contentLabel.textVerticalAlignment = .top
        let viewModel = YXEditorViewModel()

        let contentStr = viewModel.creatContent(contentList: self.postContent ?? [], isPost: true, longPressAction: longPressAction)
        contentLabel.attributedText = contentStr
        
        // 约束不精准，需手动设置最大值
        contentLabel.preferredMaxLayoutWidth = YXMainScreenWidth - contentLabel.x*2
        
        let layout = YYTextLayout(containerSize: CGSize(width: YXMainScreenWidth - contentLabel.x*2, height: CGFloat(MAXFLOAT)), text: contentStr)
        contentLabel.textLayout = layout
        let introHeight = layout?.textBoundingSize.height ?? 20
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.contentLabel.height = introHeight
            self.mainScrollV.contentSize = CGSize(width: YXMainScreenWidth, height: introHeight+20)
        }
        
    }
}
