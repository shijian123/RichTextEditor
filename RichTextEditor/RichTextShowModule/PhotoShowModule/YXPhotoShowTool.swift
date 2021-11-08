//
//  YXPhotoShowTool.swift
//  HeroGameBox
//
//  Created by zcy on 2021/6/8.
//

import Foundation
//import JXPhotoBrowser

class YXPhotoShowTool {

    /// 展示本地图片大图
    public static func showLocalBigImgMethod(_ localImgList: [UIImage], row: Int, imgView: UIImageView) {
        let browser = JXPhotoBrowser()
        
        browser.numberOfItems = {
            localImgList.count
        }
        browser.reloadCellAtIndex = { context in
            let browserCell = context.cell as? JXPhotoBrowserImageCell
            let indexPath = IndexPath(item: context.index, section: 0)
            browserCell?.imageView.image = localImgList[indexPath.item]
            // 添加长按保存事件
            browserCell?.longPressedAction = { cell, _ in
//                self.saveImageMethod(cell)
            }
        }
        browser.pageIndicator = JXPhotoBrowserNumberPageIndicator()
        browser.pageIndex = row
        browser.show()
    }
    
    /// 展示在线单张图片大图
    public static func showBigImgMethod(_ imgStrList: [String], row: Int, imgView: UIImageView?) {
        if imgView != nil {
            YXPhotoShowTool.showBigImgsMethod(imgStrList, row: row, imgViews: [imgView!])
        }else {
            YXPhotoShowTool.showBigImgsMethod(imgStrList, row: row, imgViews: [])
        }
    }
    
    /// 展示在线多张图片大图
    public static func showBigImgsMethod(_ imgStrList: [String], row: Int, imgViews: [UIImageView]?) {
        let browser = JXPhotoBrowser()
        
        browser.numberOfItems = {
            imgStrList.count
        }
        // 使用自定义的Cell
        browser.cellClassAtIndex = { _ in
            YXDownloadPhotoImageCell.self
        }
        browser.reloadCellAtIndex = { context in
            let browserCell = context.cell as? YXDownloadPhotoImageCell
            var placeholder = UIImage(named: "base_default_02")
            if context.index < imgViews?.count ?? 0 {// 尽量将原图作为占位图
                let imgView = imgViews?[context.index]
                if imgView?.image != nil {
                    placeholder = imgView?.image
                }
            }
            
            browserCell?.reloadData(placeholder: placeholder, urlString: imgStrList[context.index])
            // 添加长按保存事件
            browserCell?.longPressedAction = { cell, _ in
//                self.saveImageMethod(cell)
            }
        }
        if imgViews != nil {
            // 更丝滑的动画
            browser.transitionAnimator = JXPhotoBrowserSmoothZoomAnimator(transitionViewAndFrame: { (index, destinationView) -> JXPhotoBrowserSmoothZoomAnimator.TransitionViewAndFrame? in
                
                if imgViews?.count ?? 0 > index {
                    let imgView = imgViews![index]
                    let image = imgView.image
                    let view1 = UIImageView(image: image)
                    view1.contentMode = imgView.contentMode
                    view1.clipsToBounds = true
                    let frame1 = imgView.convert(imgView.bounds, to: destinationView)
                    return (view1, frame1)
                }else {
                    return nil
                }
            })
        }
        
        browser.pageIndicator = JXPhotoBrowserNumberPageIndicator()
        browser.pageIndex = row
        browser.show()
    }
    
    public static func loadGifImgView(_ gifImgV: YXImageView, _ urlStr: String){
                
        gifImgV.progressView.progress = 0.02
        
        gifImgV.setImage(with: urlStr, placeholderImg: gifImgV.image as Any, options: []) { received, total, url in
            if total > 0 {
                let num = CGFloat(received) / CGFloat(total)
                if num > 0.02 {
                    gifImgV.progressView.progress = num
                }
            }
        } completionHandler: { image, error, cacheType, url in
            if error == nil {
                gifImgV.showGifTag = false
                gifImgV.progressView.progress = 1.0
            }else {
                gifImgV.progressView.progress = 0
            }
        }

        /*
         
         gifImgV.kf.setImage(with: URL(string: urlStr), placeholder: gifImgV.image) {(received, total) in
             if total > 0 {
                 let num = CGFloat(received) / CGFloat(total)
                 if num > 0.02 {
                     gifImgV.progressView.progress = num
                 }
             }
         } completionHandler: {(image, error, CacheType, url) in
             
             if error == nil {
                 gifImgV.showGifTag = false
                 gifImgV.progressView.progress = 1.0
             }else {
                 gifImgV.progressView.progress = 0
 //                gifImgV.image = UIImage(named: "base_default_error_03.png")
             }
         }
         
         */
        
    }
}

