//
//  YXBaseController.swift
//  HeroGameBox
//
//  Created by zcy on 2020/12/2.
//

import UIKit

//import HeroUSDK

typealias navRightBlock = () ->Void // 声明闭包
// 声明点击头像或昵称闭包
typealias userNameOrAvatarClickBlock = (_ userID: String?) ->Void

class YXBaseController: UIViewController {
    
    var clickNavRightBlock: navRightBlock?
    /// 无网络刷新事件
    var clickRefreshButtonBlock:(()->Void)?
    
    // 当前statusBar使用的样式
    var style: UIStatusBarStyle = .default
    
    // 重现statusBar相关方法
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.style
    }
    
    var isHiddenStatusBar: Bool = false
    override var prefersStatusBarHidden: Bool {
        return isHiddenStatusBar
    }
}


// MARK: - Life Cycle

extension YXBaseController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        edgesForExtendedLayout = .all
        
        loadMainView()
        loadNavigationBar()
        addBlock()
    }
}


// MARK: Method
extension YXBaseController {
    
    // 刷新请求数据
    @objc func resetRequsetServer() {
        // 主体方法需添加：@objc dynamic
        // extension：仅需添加 @objc
    }
    
    /// 设置UI
    @objc func loadMainView() {
//        self.addNoNetworkView(frame: CGRect(x: 0, y: 0, width: YXMainScreenWidth, height: YXMainScreenHeight))
//        self.addLoginEmptyView(frame: CGRect(x: 0, y: 100, width: YXMainScreenWidth, height: 300))
    }
    /// 设置导航
    @objc func loadNavigationBar() { }
    
    /// 添加回调
    @objc func addBlock() {
        
//        self.loginEmptyView?.clickEmptyLoginBlock = {
//            if YXUser.token?.count ?? 0 < 1 {// 没有token
//                navigator.present(RouterPath.openLoginPage.rawValue)
//            }else if YXUser.userName?.count ?? 0 < 1 {
//
//                let context: [AnyHashable : Any] = [
//                    "enterType" : EnterYXMyInfoControllerType.registeredData,
//                    "isPush":false
//                ]
//                navigator.present(RouterPath.openMyInfoPage.rawValue, context: context)
//            }
//        }
//
//        self.noNetwork?.clickRefreshButtonBlock = { [weak self] in
//            self?.clickRefreshButtonBlock?()
//        }
    }

}

// MARK: - 埋点

extension YXBaseController {
    
    
    /// 获取曝光埋点页面事件ID
    @objc func getStatisticsShowEventID() -> String {
        return ""
    }
    
    
    /// 获取有导航按钮点击埋点事件ID
    @objc func getStatisticsNavRightBtnClickEventID() -> String {
        return ""
    }
}

// MARK: - 深浅颜色模式适配

extension YXBaseController { }


extension UIViewController {
    
    func addExitLoginNotification() {
        // 监控token是否失效
//        NotificationCenter.default.addObserver(self, selector: #selector(exitRefreshPageDataMethod), name: NSNotification.Name(rawValue: YXExitRefreshPageNotificationKey), object: nil)
    }
    
    ///
    @objc func exitRefreshPageDataMethod(_ noti: NSNotification) {}
}
