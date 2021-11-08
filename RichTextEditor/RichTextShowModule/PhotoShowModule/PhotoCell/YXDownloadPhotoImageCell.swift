//
//  YXDownloadPhotoImageCell.swift
//  HeroGameBox
//
//  Created by zcy on 2020/12/15.
//

import UIKit
//import JXPhotoBrowser

class YXDownloadPhotoImageCell: JXPhotoBrowserImageCell {

    /// 图片地址
    var imageUrl = ""
    /// 下载图片按钮
    var downloadBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 28, height: 29)
        btn.setImage(UIImage(named: "home_icon_download"), for: .normal)
        return btn
    }()
    
    /// 进度环
    let progressView = YXPhotoBrowserProgressView()
    
    override func setup() {
        super.setup()
        addSubview(progressView)
        downloadBtn.addTarget(self, action: #selector(clickDownloadMethod), for: .touchUpInside)
        downloadBtn.isHidden = true
        addSubview(downloadBtn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        progressView.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        downloadBtn.frame = CGRect(x: bounds.width-downloadBtn.width-16, y: bounds.height - 35 - downloadBtn.height, width: downloadBtn.width, height: downloadBtn.height)
    }
    
    func reloadData(placeholder: UIImage?, urlString: String?) {
        progressView.progress = 0
        
        imageView.setImage(with: urlString ?? "", placeholderImg: placeholder as Any, options: [.retryFailed]) { [weak self] (received, total, url) in
            if total > 0 {
                self?.progressView.progress = CGFloat(received) / CGFloat(total)
            }
        } completionHandler: { [weak self] (image, error, CacheType, url) in
            if error == nil {
                self?.imageUrl = url?.absoluteString ?? ""
                self?.progressView.progress = 1.0
                self?.downloadBtn.isHidden = false
            }else {
                self?.progressView.progress = 0
                self?.downloadBtn.isHidden = true
                self?.imageView.image = UIImage(named: "base_default_error_02")
            }
            
            self?.setNeedsLayout()
        }

    }
    
    @objc func clickDownloadMethod() {
        if let image = self.imageView.image {
            if imageUrl.isGifImageUrlString() {
                guard let data = image.sd_imageData(as: .GIF) else { return }
                YXPublicMethod.saveGifUrl(data)
            }else {
                YXPublicMethod.savePhoto(image)
            }
        }
    }
  
}

