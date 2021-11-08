//
//  YXPublicMethod.swift
//  HeroGameBox
//
//  Created by zcy on 2020/12/3.
//

import Foundation
import UIKit


// MARK: - 快照&图片处理

class YXPublicMethod: NSObject {

    /// 获取快照
    /// - Parameter inputView: 原始view
    /// - Returns: 生成的快照
    static func customSnapshoFromView(_ inputView: UIView) -> UIView {
        let snapshot = inputView.snapshotView(afterScreenUpdates: false) ?? UIView()
        snapshot.layer.masksToBounds = false
        snapshot.layer.cornerRadius = 0.0
        snapshot.layer.shadowOffset = CGSize(width: -5, height: 0)
        snapshot.layer.shadowOpacity = 0.1
        return snapshot
    }
    
    
    /// 保存图片
    static func savePhoto(_ image: UIImage) {
        if #available(iOS 14.0, *) {// 适配ios14
            TZImageManager.default().authorizationStatusAuthorized()
        }
        
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        } completionHandler: { success, error in
//            YXLog("\(success)\(String(describing: error))")
            DispatchQueue.main.async {
                if success {
                    MBProgressHUD.showText("保存成功")
                }else {
                    MBProgressHUD.showText("保存失败")
                }
            }
        }
    }
    
    /// 保存Gif图片
    static func saveGifUrl(_ gifData: Data) {
        
        if #available(iOS 14.0, *) {// 适配ios14
            TZImageManager.default().authorizationStatusAuthorized()
        }
        
        PHPhotoLibrary.shared().performChanges {
            let request = PHAssetCreationRequest.forAsset()
            request.addResource(with: PHAssetResourceType.photo, data: gifData, options: nil)
            request.creationDate = Date()
        } completionHandler: { success, error in
            DispatchQueue.main.async {
                if success {
                    MBProgressHUD.showText("保存成功")
                }else {
                    MBProgressHUD.showText("保存失败")
                }
            }
        }
    }
}

extension YXPublicMethod {
    /// 获取文字的行数
    /// - Parameters:
    ///   - attStr: 文字的属性
    ///   - width: 文字的最大宽度
    static func getNumberOfLines(_ attStr: NSAttributedString, width: CGFloat) -> Int {
        let framesetter = CTFramesetterCreateWithAttributedString(attStr)
        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: Int(width), height: Int.max))
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        // 得到字串在frame中被自动分成了多少个行
        let rows = CTFrameGetLines(frame)
        // 实际行数
        let numberOfLines = CFArrayGetCount(rows)
        return numberOfLines
        
    }
}
