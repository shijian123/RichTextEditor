//
//  ViewController.swift
//  RichTextEditor
//
//  Created by zcy on 2021/10/20.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var editBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 100, y: 100, width: 100, height: 40)
        btn.setTitle("开始编辑", for: .normal)
        btn.addTarget(self, action: #selector(clickStartEditMethod), for: .touchUpInside)
        btn.backgroundColor = .orange
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        view.addSubview(editBtn)
    }
    
    @objc func clickStartEditMethod() {
        let editVC = YXNormalEditBaseController()
        navigationController?.pushViewController(editVC, animated: true)
    }


}

