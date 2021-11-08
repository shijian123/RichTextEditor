//
//  YXEmojiDataManager.swift
//  HeroGameBox
//
//  Created by zcy on 2020/12/28.
//

import UIKit

class YXEmojiDataManager {
    lazy var emojiPackages: [YXEmojiGroupModel] = {
        var emojiPackageList:[YXEmojiGroupModel] = []
        let path = Bundle.main.path(forResource: "EmojiPackage", ofType: "bundle")
        let emojiPath = Bundle(path: path ?? "")?.path(forResource: "EmojiPackageList", ofType: "plist")
        let emojiArray = NSArray(contentsOfFile: emojiPath ?? "")
        for i in 0..<emojiArray!.count {
            let model = YXEmojiGroupModel(emojiArray![i] as! [String: Any])
            emojiPackageList.append(model)
        }
        return emojiPackageList
    }()
    var currentPackage = 0
    
    static let manager = YXEmojiDataManager.currentDataManager()

    static func currentDataManager() -> YXEmojiDataManager {
        let manager = YXEmojiDataManager()
        manager.currentPackage = 0
        return manager
    }
}

//extension YXEmojiDataManager {
//    func replaceEmoji(_ planString: String, _ attributes: Dictionary<String, Any>) {
//        let attStr = NSAttributedString(string: planString, attributes: attributes)
//
//    }
//}
