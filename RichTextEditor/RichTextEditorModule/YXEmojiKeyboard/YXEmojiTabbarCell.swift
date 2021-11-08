//
//  YXEmojiTabbarCell.swift
//  HeroGameBox
//
//  Created by zcy on 2021/7/27.
//

import UIKit
import SnapKit

class YXEmojiTabbarCell: UICollectionViewCell {
    lazy var itemImgV: UIImageView = {
        let imgV = UIImageView()
        return imgV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(self.itemImgV)
        self.itemImgV.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.width.height.equalTo(26)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
