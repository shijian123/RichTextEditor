//
//  YXLinkCardView.swift
//  HeroGameBox
//
//  Created by zcy on 2021/10/12.
//

import UIKit

class YXLinkCardView: UIView {
        
    private var spaceNum: CGFloat = 5
    
    lazy var iconImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleToFill
        imgView.layer.masksToBounds = true
        imgView.layer.cornerRadius = 8
        return imgView
    }()
    
    lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.colorWith(lightColor: "0x121212", darkColor: "0xdddddd")
        lab.font = .systemFont(ofSize: 16, weight: .medium)
        return lab
    }()
    
    lazy var subTitleLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.colorWith(lightColor: "0x666666", darkColor: "0x979AA2")
        lab.font = .systemFont(ofSize: 14)
        return lab
    }()
    
    lazy var linkView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.width, height: 60))
        
        view.addSubview(self.iconImgView)
        view.addSubview(self.titleLab)
        view.addSubview(self.subTitleLab)
        
        iconImgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(6)
            make.width.height.equalTo(48)
        }
        
        titleLab.snp.makeConstraints { make in
            make.left.equalTo(iconImgView.snp_right).offset(8)
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
        }

        subTitleLab.snp.makeConstraints { make in
            make.left.equalTo(iconImgView.snp_right).offset(8)
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        return view
    }()
    
    lazy var lineView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIColor.colorWith(lightColor: "0x000000", lightColorAlpha: 0.3, darkColor: "0xffffff", darkColorAlpha: 0.3)
        return imgView
    }()
    
    lazy var headImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.masksToBounds = true
        imgView.layer.cornerRadius = 12
        return imgView
    }()
    
    lazy var nickNameLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.colorWith(lightColor: "0x2D3556", darkColor: "0xDDDDDD")
        lab.font = .systemFont(ofSize: 14, weight: .semibold)
        return lab
    }()
    
    lazy var userView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.width, height: 36))
        view.addSubview(self.lineView)
        view.addSubview(self.headImgView)
        view.addSubview(self.nickNameLab)
        
        lineView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(0.5)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(6)
        }
        
        headImgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
            make.left.equalTo(lineView.snp_left)
        }
        
        nickNameLab.snp.makeConstraints { make in
            make.left.equalTo(headImgView.snp_right).offset(8)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-8)
        }
        
        return view
    }()
    
    convenience init(model: YXPostLinkCardModel) {
        self.init()
        frame = CGRect(x: 16, y: 0, width: YXMainScreenWidth-32, height: 60)
        addSubviewMethod(model)
        resetCardView(model)
    }
    
    func addSubviewMethod(_ model: YXPostLinkCardModel) {
        let mainView = UIView(frame: CGRect(x: 0, y: spaceNum, width: self.width, height: 60))
        mainView.backgroundColor = UIColor.colorWith(lightColor: "0xF4F4FF", darkColor: "0x4B4858")

        mainView.addSubview(self.linkView)
        if model.postId?.count ?? 0 > 2 {
            if model.nickName?.count ?? 0 < 1 {// 贴子异常，不显示用户信息
                mainView.height = self.linkView.frame.maxY
            }else {
                mainView.addSubview(self.userView)
                self.userView.y = self.linkView.frame.maxY
                mainView.height = self.userView.frame.maxY
            }
            
        }else {
            mainView.height = self.linkView.frame.maxY
        }
        mainView.layer.masksToBounds = true
        mainView.layer.cornerRadius = 8
        addSubview(mainView)
        height = mainView.frame.maxY+spaceNum
    }
    
    func resetCardView(_ model: YXPostLinkCardModel) {
        
        iconImgView.setImage(with: model.iconUrl ?? "", placeholderImgStr: "base_default_04", errorImgStr: "base_default_error_04", isAbnormal: false, isShowGif: false, completionHandler: nil)
        
        if model.postId?.count ?? 0 > 2 {
            titleLab.text = model.title
            headImgView.setImage(with: model.headUrl ?? "", placeholderImgStr: "base_headImg_default")
            nickNameLab.text = model.nickName
            
            if model.subTitle?.count ?? 0 > 0 {
                subTitleLab.isHidden = false
                subTitleLab.text = model.subTitle

            }else {
                subTitleLab.isHidden = true
                titleLab.snp.remakeConstraints { make in
                    make.left.equalTo(iconImgView.snp_right).offset(8)
                    make.centerY.equalToSuperview()
                    make.right.equalToSuperview().offset(-8)
                }
            }
            
        }else {
            subTitleLab.text = model.url
            if model.title?.count ?? 0 > 0 {
                titleLab.text = model.title
                titleLab.isHidden = false
            }else {
                titleLab.isHidden = true
                subTitleLab.snp.remakeConstraints { make in
                    make.left.equalTo(iconImgView.snp_right).offset(8)
                    make.centerY.equalToSuperview()
                    make.right.equalToSuperview().offset(-8)
                }
            }
            
        }
        
    }

}
