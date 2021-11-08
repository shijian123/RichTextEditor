//
//  YXImageView.swift
//  HeroGameBox
//
//  Created by zcy on 2021/7/15.
//

import UIKit

class YXImageView: UIImageView {
    
    /// 是否显示gif图标
    var showGifTag: Bool = false {
        didSet {
            self.gifImgView.isHidden = !showGifTag
        }
    }    
    
    lazy var gifImgView: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "base_icon_gif"))
        imgView.isHidden = true
        return imgView
    }()
    
    /// 进度环
    lazy var progressView: YXPhotoBrowserProgressView = {
        let proV = YXPhotoBrowserProgressView()
        proV.isHidden = true
        return proV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGifTagView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addGifTagView()
    }
    
}


fileprivate extension YXImageView {
    
    func addGifTagView() {
        addSubview(self.gifImgView)
        addSubview(self.progressView)

        self.gifImgView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-4)
            make.bottom.equalToSuperview().offset(-4)
            make.width.equalTo(24)
            make.height.equalTo(14)
        }
        self.progressView.center = self.center
    }
}
