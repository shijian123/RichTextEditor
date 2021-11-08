//
//  YXBaseWithNavigationBarViewController.swift
//  HeroGameBox
//
//  Created by zdd on 2021/4/9.
//

import UIKit

/// 有导航
class YXBaseWithNavigationBarViewController: YXBaseController {
    
    /// 是否 自定义modal 动画
    var isCustomPresent: Bool = false
    
    /// 导航
    var navView: UIView = {
        let navV = UIView(frame: CGRect(x: 0, y: 0, width: YXMainScreenWidth, height: YXNavBarHight))
        return navV
    }()
    
    var navBackGroundView: UIView = {
        let navV = UIView(frame: CGRect(x: 0, y: 0, width: YXMainScreenWidth, height: YXNavBarHight))
        navV.backgroundColor = UIColor(hexString: "0xffffff")
        return navV
    }()
    
    lazy var watermarkView: UIView = {
        let view = UIView(frame: CGRect(x: (YXMainScreenWidth - 60)/2, y: 10, width: 60, height: 20))
        
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imgView.image = UIImage(named: "base_icon")
        imgView.contentMode = .scaleAspectFit
        view.addSubview(imgView)
        
        let lab = UILabel(frame: CGRect(x: imgView.frame.maxY + 3, y: 3, width: 35, height: 17))
        lab.text = "摸鱼社"
        lab.textColor = UIColor.colorWith(lightColor: "0x121212", darkColor: "0xdddddd")
        lab.textAlignment = .left
        lab.font = .systemFont(ofSize: 11)
        view.addSubview(lab)
        
        view.isHidden = true
        return view
    }()
    
    /// 返回
    lazy var navBackBtn: UIButton = {
        
        let leftBtn = UIButton(frame: CGRect(x: NavBarConfig.navLeftMargin, y: YXStatusBarHight, width:  NavBarConfig.navBtnWidth, height: NavBarConfig.navBtnHeight))
        leftBtn.setImage(UIImage(named: "base_nav_return"), for: .normal)
        leftBtn.contentMode = .center
        leftBtn.addTarget(self, action: #selector(navBackBtnAction), for: .touchUpInside)
        return leftBtn
    }()
    
    /// 标题
    lazy var navTitleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: NavBarConfig.navLeftMargin + NavBarConfig.navBtnWidth, y: YXStatusBarHight, width: NavBarConfig.navDefuletTitleWidth, height: NavBarConfig.navBtnHeight))
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    /// 标题View
    lazy var navTitleView: UIView = {
        let label = UIView(frame: CGRect(x: NavBarConfig.navLeftMargin + NavBarConfig.navBtnWidth, y: YXStatusBarHight, width: NavBarConfig.navDefuletTitleWidth, height: NavBarConfig.navBtnHeight))
        return label
    }()
    
    /// 右边按钮
    lazy var navRightBtn: UIButton = {
        
        let rightBtn = UIButton(frame: CGRect(x: YXMainScreenWidth - NavBarConfig.navBtnWidth - NavBarConfig.navRightMargin, y: YXStatusBarHight, width: NavBarConfig.navBtnWidth, height: NavBarConfig.navBtnHeight))
        rightBtn.contentMode = .center
        rightBtn.addTarget(self, action: #selector(navRightBtnAction), for: .touchUpInside)

        return rightBtn
        
    }()
    /// 发布
    lazy var navRightPublishBtn: UIButton = {
        let rightBtn = UIButton(type: .system)
        rightBtn.setTitle("发布", for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        rightBtn.setTitleColor(.white, for: .normal)
//        rightBtn.setTitleColor(UIColor(hexString: "0x666666"), for: .disabled)
        rightBtn.backgroundColor = UIColor(hexString: "0xDFDEE4")
        rightBtn.layer.cornerRadius = 16
        rightBtn.layer.masksToBounds = true
        rightBtn.isEnabled = false
        rightBtn.addTarget(self, action: #selector(navPublishPostBtnAction), for: .touchUpInside)
        return rightBtn
    }()
    
    
    lazy var navShareBtn: UIButton = {
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("发布", for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        rightBtn.setTitleColor(.white, for: .normal)
        rightBtn.backgroundColor = UIColor(hexString: "0x86A0FE")
        rightBtn.setTitleColor(.blue, for: .normal)
        rightBtn.layer.cornerRadius = 16
        rightBtn.layer.masksToBounds = true
        rightBtn.isEnabled = false
        rightBtn.addTarget(self, action: #selector(navShareBtnAction), for: .touchUpInside)
        return rightBtn
    }()
    
    lazy var navUserInfoView: UIView = {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: NavBarConfig.navDefuletTitleWidth, height: NavBarConfig.navBtnHeight))
        view.backgroundColor = .clear
        let headImgV = UIImageView(frame: CGRect(x: 0, y: (NavBarConfig.navBtnHeight - 30)/2, width: 30, height:30))
        headImgV.tag = 101
        headImgV.layer.masksToBounds = true
        headImgV.layer.cornerRadius = 15
        headImgV.layer.borderWidth = 1
        headImgV.image = UIImage(named: "base_headImg_default")
        view.addSubview(headImgV)

        let lab = UILabel(frame: CGRect(x: headImgV.frame.maxX+10, y: (NavBarConfig.navBtnHeight - 20)/2, width: 100, height: 20))
        lab.textColor = .red
        lab.tag = 102
        lab.text = ""
        lab.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        view.addSubview(lab)
        
        
        let headBtn = UIButton(type: .custom)
        headBtn.tag = 1000
        headBtn.backgroundColor = .clear
        headBtn.frame = CGRect(x: 0, y: 0, width: lab.frame.maxX, height: 44)
        headBtn.addTarget(self, action: #selector(navHeadInfoClickAction), for: .touchUpInside)
        view.addSubview(headBtn)
        
        view.alpha = 0
        return view
    }()
    
}

// MARK: - Life Cycle

extension YXBaseWithNavigationBarViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.isHidden = true
//        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

// MARK: - Methed

extension YXBaseWithNavigationBarViewController {
    
    @objc override func loadNavigationBar() {
        super.loadNavigationBar()
        
        self.view.addSubview(self.navView)
        
        self.navView.addSubview(self.navBackGroundView)
        if isBangsScreen {
            self.navView.addSubview(self.watermarkView)
        }
        self.navView.addSubview(self.navBackBtn)
        self.navView.addSubview(self.navTitleLabel)
        self.navView.addSubview(self.navTitleView)
        self.navView.addSubview(self.navRightBtn)
        
        self.navTitleView.addSubview(self.navUserInfoView)
        
    }

    /// 返回事件
    @objc func navBackBtnAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// 右按钮事件
    @objc func navRightBtnAction() { }
    
    /// 导航发布点击事件
    @objc func navPublishPostBtnAction(sender: UIButton) { }
    
    /// 导航分享 更多点击事件
    @objc func navShareBtnAction(sender: UIButton) { }
    
    
    /// 导航头像昵称点击
    @objc func navHeadInfoClickAction() { }
}


extension YXBaseWithNavigationBarViewController {

    /// 设置导航透明度
    /// - Parameter alpha: 透明度
    func setNavBarAlpha(alpha: CGFloat) {
        navBackGroundView.alpha = alpha

    }    
    

}




struct NavBarConfig {
    
    
    static let navBtnWidth: CGFloat    = 40.0
    static let navBtnHeight: CGFloat   = 44.0
    
    static let navLeftMargin: CGFloat  = 6.0
    static let navRightMargin: CGFloat = 6.0
    static let navBtnMargin: CGFloat   = 4.0
   
    
    static let navDefuletTitleWidth  = YXMainScreenWidth - navBtnWidth * 2 - navLeftMargin - navRightMargin
    
    static let navTitleWidthWithTwoRightBtn  = YXMainScreenWidth - navBtnWidth * 3 - navLeftMargin - navRightMargin - navBtnMargin
    
    static let navSecondRightBtnX  = YXMainScreenWidth - navBtnWidth * 2 - navRightMargin - navBtnMargin
    
}
