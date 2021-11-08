//
//  YXEmojiInputView.swift
//  HeroGameBox
//
//  Created by zcy on 2020/12/28.
//

import UIKit

class YXEmojiInputView: UIView {

    var clickEmojiItemBlock:((_ model: YXEmojiItemModel)-> Void)?
    var clickDeleteEmojiBlock:(()-> Void)?
    
    lazy var contentView: YXEmojiContentView = {
        let view = YXEmojiContentView(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height-40-CGFloat(YXScreenBottomH)))
        view.backgroundColor = UIColor.colorWith(lightColor: "0xF8F8F8", darkColor: "0x121212")
        view.clickEmojiItemBlock = {[weak self] (model) in
            self?.clickEmojiItemBlock?(model)
        }
        view.updateTabbarItemClosure = {[unowned self] (num) in
            self.tabbarView.currentItem = num
        }
        return view
    }()
    
    lazy var tabbarView: YXEmojiTabbar = {
        let tabbarV = YXEmojiTabbar.loadFromNib()!
        tabbarV.frame = CGRect(x: 0, y: self.height-40-CGFloat(YXScreenBottomH), width: self.width, height: 40)
        tabbarV.setupUI()
        tabbarV.clickEmojiPackageBlock = {[unowned self] (row) in
            
            self.contentView.currentItem = row
        }
        tabbarV.clickDeleteEmojiBlock = {[weak self] in
            self?.clickDeleteEmojiBlock?()
        }
        
        return tabbarV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(self.contentView)
        addSubview(self.tabbarView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
