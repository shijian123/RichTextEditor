//
//  DispatchQueue+Extension.swift
//  HeroGameBox
//
//  Created by zcy on 2021/9/27.
//

import Foundation

extension DispatchQueue {
    private static var _onceToken = [String]()
    
    class func once(token: String = "\(#file):\(#function):\(#line)", block: ()->Void) {
        objc_sync_enter(self)
        
        defer {
            objc_sync_exit(self)
        }

        if _onceToken.contains(token) {
            return
        }

        _onceToken.append(token)
        block()
    }
}
