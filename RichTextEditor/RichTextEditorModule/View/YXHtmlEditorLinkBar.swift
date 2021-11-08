//
//  YXHtmlEditorLinkBar.swift
//  HeroGameBox
//
//  Created by zcy on 2021/9/29.
//

import UIKit

class YXHtmlEditorLinkBar: UIView, Nibloadable {

    var clickItemBlock:((_ item: Int)-> Void)?

    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var linkView: UIView!
    @IBOutlet weak var linkTF: UITextField!
    @IBOutlet weak var urlTitleView: UIView!
    @IBOutlet weak var titleTF: UITextField!
    // 快速链接的底部
    @IBOutlet weak var quickBgView: UIImageView!
    @IBOutlet weak var quickView: UIView!
    // 快速链接的内容
    @IBOutlet weak var quickLab: UILabel!
    
    // 快速链接url
    var quickUrlStr = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }
    
}

// MARK: - Method

extension YXHtmlEditorLinkBar {
    
    func resetQuickView() {
        let urlList = UIPasteboard.general.string?.matchURLList() ?? []
        
        if urlList.count > 0 {
            quickUrlStr = urlList[0]
            self.quickLab.text = "点击快速插入链接：\(quickUrlStr)"
            self.quickBgView.isHidden = false
            self.quickView.isHidden = false
        }else {
            self.quickBgView.isHidden = true
            self.quickView.isHidden = true
        }
    }
    
    func hiddQuickBgView() {
        if !self.quickView.isHidden {
            self.quickBgView.isHidden = true
            self.quickView.isHidden = true
        }
    }
    
}

// MARK: - Action

extension YXHtmlEditorLinkBar {
    /// 点击编辑bar，100：取消，101：添加
    @IBAction func clickItemAction(_ sender: UIButton) {
        sender.avoidRepeatMethod()
        self.clickItemBlock?(sender.tag - 100)
    }
    
    
    @IBAction func clickQuickContentAction(_ sender: Any) {
        linkTF.text = self.quickUrlStr
        hiddQuickBgView()
    }
    
    @IBAction func closeQuickViewAction(_ sender: Any) {
        hiddQuickBgView()
    }
    
}

extension YXHtmlEditorLinkBar: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        hiddQuickBgView()
        return true
    }
    
}

// MARK: - 深浅模式
extension YXHtmlEditorLinkBar {
    func configUI() {
        backgroundColor = UIColor.colorWith(lightColor: "0xffffff", darkColor: "0x181818")
        titleLab.textColor = UIColor.colorWith(lightColor: "0x121212", darkColor: "0xDDDDDD")
        linkView.backgroundColor = UIColor.colorWith(lightColor: "0xB9C7FF", lightColorAlpha: 0.14, darkColor: "0x252525")
        urlTitleView.backgroundColor = UIColor.colorWith(lightColor: "0xB9C7FF", lightColorAlpha: 0.14, darkColor: "0x252525")
        quickLab.textColor = UIColor.colorWith(lightColor: "0xffffff", darkColor: "0x121212")
    }
}

