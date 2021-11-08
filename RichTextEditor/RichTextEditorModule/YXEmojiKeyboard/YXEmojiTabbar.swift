//
//  YXEmojiTabbar.swift
//  HeroGameBox
//
//  Created by zcy on 2020/12/28.
//

import UIKit

class YXEmojiTabbar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, Nibloadable {

    var clickDeleteEmojiBlock:(()-> Void)?
    var clickEmojiPackageBlock:((_ row: Int) -> Void)?
    
    @IBOutlet weak var myTabbarCollV: UICollectionView!
    
    var dataList: [YXEmojiGroupModel] = []
    /// 设置当前的item
    var currentItem: Int = 0 {
        didSet {
            let groupNum = YXEmojiDataManager.manager.emojiPackages.count
            if currentItem < groupNum {
                YXEmojiDataManager.manager.currentPackage = currentItem
                myTabbarCollV.reloadData()
            }
        }
    }
}


// MARK: Method

extension YXEmojiTabbar {
    
    func setupUI() {
        self.backgroundColor = UIColor.colorWith(lightColor: "0xFFFFFF", darkColor: "0x202020")
        myTabbarCollV.register(YXEmojiTabbarCell.self, forCellWithReuseIdentifier: "YXEmojiTabbarCell")
        myTabbarCollV.delegate = self
        myTabbarCollV.dataSource = self
        dataList = YXEmojiDataManager.manager.emojiPackages
    }
    
    /// 获取表情包封面图片
    func groupCoverImg(_ groupModel: YXEmojiGroupModel) -> String {
        let path = Bundle.main.path(forResource: "EmojiPackage", ofType: "bundle") ?? ""
        let folderPath = Bundle(path: path)?.path(forResource: groupModel.folderName, ofType: nil) ?? ""
        let coverPath = "\(folderPath)/"+groupModel.cover_pic!
        return coverPath
    }
}


// MARK: Action

extension YXEmojiTabbar {
    @IBAction func deleteEmojiAction(_ sender: Any) {
        self.clickDeleteEmojiBlock?()
    }
}


// MARK: Delegate

extension YXEmojiTabbar {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXEmojiTabbarCell", for: indexPath) as! YXEmojiTabbarCell
        let model = dataList[indexPath.row]
//        let imagePath = groupCoverImg(model)
//        cell.itemImgV.image = UIImage(contentsOfFile: imagePath)
        cell.itemImgV.image = UIImage(named: model.cover_pic ?? "")
        if indexPath.row == YXEmojiDataManager.manager.currentPackage {
            cell.backgroundColor = UIColor.colorWith(lightColor: "0xF8F8F8", darkColor: "0x33333e")

        }else {
            cell.backgroundColor = UIColor.colorWith(lightColor: "0xFFFFFF", darkColor: "0x202020")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        YXEmojiDataManager.manager.currentPackage = indexPath.row
        self.clickEmojiPackageBlock?(indexPath.row)
        collectionView.reloadData()
    }
}
