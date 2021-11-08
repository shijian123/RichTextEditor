//
//  YXUploadImagesManager.swift
//  HeroGameBox
//
//  Created by zdd on 2021/5/19.
//

import Foundation

class YXUploadImagesManager: NSObject {
    
    /// web插入图片
    var webViewInsertImageClosure: ((YXHtmlUploadPictureModel) -> Void)?
    var webViewInsertImageKeyClosure: ((YXHtmlUploadPictureModel, CGFloat) -> Void)?
    var webViewInsertImageSuccessClosure: ((String, String, CGSize) -> Void)?
    
    var webViewAppendImageClosure: ((YXHtmlUploadPictureModel) -> Void)?
   
    /// 开始上传 回调
    var uploadPhotoBeginClosure: (() -> Void)?
    /// 上传完成 回调
    var uploadPhotoFinishClosure: ((Bool) -> Void)?

    var uploadPics: [YXHtmlUploadPictureModel] = []
    
    
    
    
}


extension YXUploadImagesManager {

    /// 开始上传图片
    /// - Parameters:
    ///   - photos: 上传的图片
    ///   - isAppend: 是否是追加上传 0 非追加  1 追加
    func startUploadPhotoMethod(_ photos: [YXUploadImageModel], isAppend: Bool = false) {

        // 判断非追加上传，处理webview
        if isAppend == false {
            self.uploadPhotoBeginClosure?()
        }
        
        for _ in photos {
            let fileM = YXHtmlUploadPictureModel()
            let img = UIImage(named: "base_default_img.png")
            fileM.imageData = img!.pngData()
            fileM.key = NSString.imageUUID()
            self.uploadPics.append(fileM)
            
            // 判断非追加上传，处理webview
            if isAppend == false {
                self.webViewInsertImageClosure?(fileM)
            }else {
                self.webViewAppendImageClosure?(fileM)
            }
           
            self.webViewInsertImageKeyClosure?(fileM, 0.3)
 
        }
//        let hud = MBProgressHUD.showAddHud()
//        YXNetManager.shareInstance.requestUploadImageData(urlString: "\(YXNetInfo.apiUploadForumImg)", datas: photos) {[weak self] (reseult, error) in
//            hud.hide(animated: true, afterDelay: 0.3)
//            let code = reseult["code"] as? Int
//
//            if code != YXNetInfo.code200 {// 报错请求内部已处理
//                //3、上传失败, 删除图片
//                for fileM in self!.uploadPics {
//
//                    self?.webViewInsertImageSuccessClosure?(fileM.key ?? "", "imgLoadError", CGSize(width: 10, height: 8))
//                    self?.uploadPics.removeAll{$0 == fileM}
//
//                }
//
//            }else {
//                let imgUrls = reseult["data"] as? [String]
//
//                let uploadPicArr = self?.uploadPics
//                for i in 0..<uploadPicArr!.count {
//
//                    let model: YXUploadImageModel = photos[i]
//
//                    let fileM = uploadPicArr![i]
//                    let imgUrl = imgUrls?[i]
//                    let img = model.image
//                    self?.webViewInsertImageKeyClosure?(fileM, 1.0)
//                    self?.webViewInsertImageSuccessClosure?(fileM.key!, imgUrl!, img!.size)
//                    NSLog("插入图片:\(imgUrl ?? "")")
//                    self?.uploadPics.removeAll{$0 == fileM}
//                }
//            }
//            // 避免图片上传失败
//            for fileM in self?.uploadPics ?? [] {
//                self?.webViewInsertImageSuccessClosure?(fileM.key ?? "", "imgLoadError", CGSize(width: 10, height: 8))
//                self?.uploadPics.removeAll{$0 == fileM}
//            }
//            self?.uploadPhotoFinishClosure?(true)
//
//        }
    }
}

