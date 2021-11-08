//
//  YXTextAttachment.swift
//  HeroGameBox
//
//  Created by zcy on 2020/12/28.
//

import UIKit

class YXTextAttachment: NSTextAttachment {
    var imageName: String?
    var desc: String?

    static func attachment(_ emoji: YXEmojiItemModel, _ font: UIFont) -> YXTextAttachment {
        let attachment = YXTextAttachment()
        attachment.imageName = emoji.imageName
        attachment.desc = emoji.desc
        attachment.bounds = CGRect(x: 0, y: font.descender, width: font.lineHeight, height: font.lineHeight)
        attachment.image = emoji.image
        return attachment
    }
    
}
