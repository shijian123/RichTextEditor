//
//  YXHtmlEditorBar.swift
//  HeroGameBox
//
//  Created by zcy on 2020/12/17.
//

import UIKit

class YXHtmlEditorBar: UIView, Nibloadable {

    var clickEditItemBlock:((_ editorBar:YXHtmlEditorBar, _ item: Int) -> Void)?
    
    @IBOutlet weak var numView: UIView!
    @IBOutlet weak var counterNumLab: UILabel!
    @IBOutlet weak var emojiBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }
    
    
    @IBAction func clickEditItemAction(_ sender: UIButton) {
        self.clickEditItemBlock?(self, sender.tag-100)
    }
}

// MARK: - 深浅模式
extension YXHtmlEditorBar {
    func configUI() {
        numView.backgroundColor = UIColor.colorWith(lightColor: "0xffffff", darkColor: "0x151515")
        backgroundColor = UIColor.colorWith(lightColor: "0xffffff", darkColor: "0x1D1D27")
        counterNumLab.textColor = UIColor.colorWith(lightColor: "0xcccccc", darkColor: "0x898FA3")
    }
}
