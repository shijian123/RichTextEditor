//
//  YXEditorShowController.swift
//  RichTextEditor
//
//  Created by zcy on 2021/11/3.
//

import UIKit

class YXEditorShowController: UIViewController {

    var postContent: [YXPostContentModel]? = []
    var longPressAction: YXTextAction?
    
    lazy var mainScrollV: UIScrollView = {
        let scrollV = UIScrollView(frame: self.view.bounds)
        scrollV.addSubview(contentLabel)
        return scrollV
    }()
    
    lazy var contentLabel: YYLabel = {
        let lab = YYLabel(frame: self.view.bounds)
        return lab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "详情"
        view.addSubview(mainScrollV)
        
        // 设置贴子内容
        setupContentMethod()

        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.mainScrollV.contentSize = CGSize(width: YXMainScreenWidth, height: self.contentLabel.height)
        }
    }

    
    /// 更新贴子内容
    func setupContentMethod() {
        contentLabel.numberOfLines = 0
        contentLabel.clearContentsBeforeAsynchronouslyDisplay = true
        contentLabel.textVerticalAlignment = .top
        let viewModel = YXEditorViewModel()

        let contentStr = viewModel.creatContent(contentList: self.postContent ?? [], isPost: true, longPressAction: longPressAction)
        contentLabel.attributedText = contentStr
        // 约束不精准，需手动设置最大值
        contentLabel.preferredMaxLayoutWidth = YXMainScreenWidth - contentLabel.x*2
    }
}
