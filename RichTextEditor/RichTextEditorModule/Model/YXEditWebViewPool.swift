//
//  YXEditWebViewPool.swift
//  HeroGameBox
//
//  Created by zcy on 2020/12/18.
//

import UIKit

class YXEditWebViewPool: NSObject {

    lazy var webView: YXEditWebView = {
        let webView = YXEditWebView()
        webView.scrollView.alwaysBounceVertical = true
        webView.scrollView.alwaysBounceHorizontal = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.backgroundColor = .clear
        webView.isOpaque = false
//        webView.setStyleDark(isDark: true)
        return webView
    }()
    
//    static let shareInstance = YXEditWebViewPool.currentPool
    
    class var shareInstance: YXEditWebViewPool {
        return YXEditWebViewPool()
    }
    
//    func setupWebView() {
//        let baseURL = URL(fileURLWithPath: Bundle.main.bundlePath)
//        let htmlPath = Bundle.main.path(forResource: "richText_editor", ofType: "html")
//        let htmlCont = try? String(contentsOfFile: htmlPath!, encoding: .utf8)
//        self.webView.loadHTMLString(htmlCont!, baseURL: baseURL)
//    }
    
}
