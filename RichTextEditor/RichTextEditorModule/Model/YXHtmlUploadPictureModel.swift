//
//  YXHtmlUploadPictureModel.swift
//  HeroGameBox
//
//  Created by zcy on 2020/12/18.
//

import UIKit

enum YXUploadImageModelType {
        /// 上传中
    case YXUploadImageModelTypeNone
         /// 上传失败
    case YXUploadImageModelTypeError
         /// 上传成功
    case YXUploadImageModelTypeSuccess
}

class YXHtmlUploadPictureModel: NSObject {
    var type: YXUploadImageModelType?
    var host: String?
    var fileName: String?
    var key: String?
    var token: String?
    var filePath: String?
    var imageData: Data?
    var fileData: Data?
    var image: UIImage?
}
