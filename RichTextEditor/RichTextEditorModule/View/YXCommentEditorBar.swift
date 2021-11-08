//
//  YXCommentEditorBar.swift
//  HeroGameBox
//
//  Created by zcy on 2021/3/1.
//

import UIKit

class YXCommentEditorBar: UIView, Nibloadable {
    
    var clickItemBlock:((_ sender: UIButton)-> Void)?
    
    @IBOutlet weak var senderBtn: UIButton!
    /// 点击编辑bar，100：发送，101：表情包，102：图片
    @IBAction func clickItemAction(_ sender: UIButton) {
        sender.avoidRepeatMethod()
        self.clickItemBlock?(sender)
    }
    
    
}
