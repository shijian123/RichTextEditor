//
//  YXImagePickerController.swift
//  HeroGameBox
//
//  Created by zcy on 2021/3/4.
//

import UIKit

class YXImagePickerController: TZImagePickerController {
    
    
    var selectPhotosFinishClosure: ((_ photos: [YXUploadImageModel]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImagePickerConfig()
    }
    
    func setupImagePickerConfig() {
        self.allowPickingVideo = false
        self.iconThemeColor = UIColor(hexString: "0x7352FF")
        // self.showSelectedIndex = true
        self.photoWidth = 1200
        self.allowTakeVideo = false
        self.allowCameraLocation = false
        self.allowPickingOriginalPhoto = false
        self.autoSelectCurrentWhenDone = false
        self.sortAscendingByModificationDate = false
        self.oKButtonTitleColorNormal = UIColor(hexString: "0x7352FF")
        self.oKButtonTitleColorDisabled = UIColor(hexString: "0x7352FF", alpha: 0.6)
        
        self.showGifTag = true
        self.didFinishPickingPhotosHandle = { [weak self] (photos, assets, isSelectOriginalPhoto) in
            let images: [YXUploadImageModel] = self?.getUploadDataModels(assets: assets!) ?? []
            self?.selectPhotosFinishClosure?(images)
        }

    }
    
    func getUploadDataModels(assets: [Any]) -> [YXUploadImageModel] {
        
        var iamgeDataModel: [YXUploadImageModel] = []
        
        let options = PHImageRequestOptions()
        options.resizeMode = .fast
        options.isSynchronous = true
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .fastFormat
        let imageManager = PHCachingImageManager()
        
        for asset in assets {
            imageManager.requestImageData(for: asset as! PHAsset, options: options) { (imageData, dataUTI, orientation, info) in
                
                var image = UIImage(data: imageData ?? Data())
                if dataUTI == "com.compuserve.gif" {
                                        
                    // gif图片压缩到1MB以下
                    let newImage = UIImage(data: imageData!)
                    let model = YXUploadImageModel(data: imageData, type: .gifImage, image: newImage)
                    iamgeDataModel.append(model)
                    
                }else {
                    
                    let data = image?.compress(withMaxLengthKB: 1024)
                    image = UIImage(data: data!)
                    let model = YXUploadImageModel(data: data, type: .image, image: image)
                    iamgeDataModel.append(model)
                }
            }
        }
        
        return iamgeDataModel
    }
    
}
