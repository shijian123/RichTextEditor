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
