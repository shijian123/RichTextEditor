//
//  YXEmojiContentView.swift
//  HeroGameBox
//
//  Created by zcy on 2020/12/28.
//

import UIKit

class YXEmojiContentView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    /// 点击表情回调
    var clickEmojiItemBlock:((_ model: YXEmojiItemModel) -> Void)?
    /// 更新切换tabbar的Num
    var updateTabbarItemClosure:((_ num: Int) -> Void)?
    /// 设置当前的item
    var currentItem = 0 {
        didSet {
            let groupNum = YXEmojiDataManager.manager.emojiPackages.count
            if currentItem < groupNum {
                emojiScrollView.contentOffset = CGPoint(x: currentItem*Int(self.emojiScrollView.width), y: 0)
            }
        }
    }
    
    fileprivate lazy var emojiScrollView: UIScrollView = {
        let view = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height-10))
        view.delegate = self
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.isPagingEnabled = true
        return view
    }()
    
//    lazy var emojiPageCont: UIPageControl = {
//        let pageCont = UIPageControl(frame: CGRect(x: 0, y: self.height-30, width: self.width, height: 30))
//        return pageCont
//    }()
    
    fileprivate var pageEmojis:[[YXEmojiItemModel]] = []
    fileprivate var groupModel: YXEmojiGroupModel?
    
    /// 小表情行数
    fileprivate var smallEmojiLineCount: CGFloat = 3
    /// 小表情列数
    fileprivate var smallEmojiColumnCount: CGFloat = 7
    /// 小表情间距
    fileprivate var smallEmojiSpacing: CGFloat = 20
    /// 大表情行数
    fileprivate var largeEmojiLineCount: CGFloat = 2
    /// 大表情列数
    fileprivate var largeEmojiColumnCount: CGFloat = 5
    /// 大表情间距
    fileprivate var largeEmojiSpacing: CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(self.emojiScrollView)
        addContentView()

//        addSubview(self.emojiPageCont)
//        reloadContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Method

fileprivate extension YXEmojiContentView {
    
    /// 创建表情内容
    func addContentView() {
        let groupNum = YXEmojiDataManager.manager.emojiPackages.count
        emojiScrollView.contentSize = CGSize(width: self.width*CGFloat(groupNum), height: emojiScrollView.height)

        pageEmojis = []
        for i in 0..<groupNum {
            let groupModel = YXEmojiDataManager.manager.emojiPackages[i]
            pageEmojis.append(groupModel.emojis ?? [])
            
            let frame = CGRect(x: CGFloat(i)*self.emojiScrollView.width, y: 0, width: self.emojiScrollView.width, height: self.emojiScrollView.height)
            let view = creatCollectionViewFrame(frame, isLargeEmoji: groupModel.isLargeEmoji ?? false)
            view.tag = 100+i
            self.emojiScrollView.addSubview(view)
        }
        
        emojiScrollView.contentOffset = CGPoint(x:YXEmojiDataManager.manager.currentPackage*Int(self.emojiScrollView.width), y: 0)
    }
    
    /*
    func reloadContentView() {
        for view in self.emojiScrollView.subviews {
            if view.isKind(of: UIView.self) {
                view.removeFromSuperview()
            }
        }
        
        let num = YXEmojiDataManager.manager.currentPackage
        groupModel = YXEmojiDataManager.manager.emojiPackages[num]
        
        var pageNum = 0
        var pageSize = 0
        
        if (groupModel?.isLargeEmoji ?? false) {// 大表情
            pageSize = Int((largeEmojiLineCount*largeEmojiColumnCount));
            pageNum = Int(ceilf(Float((groupModel?.emojis?.count ?? 0)/pageSize)))
        }else {
            pageSize = Int((smallEmojiLineCount*smallEmojiColumnCount));
            pageNum = Int(ceilf(Float((groupModel?.emojis?.count ?? 0)/pageSize)))
        }
        emojiScrollView.contentSize = CGSize(width: self.width*CGFloat(pageNum), height: emojiScrollView.height)
        pageEmojis = []
        for i in 0..<pageNum {
            let frame = CGRect(x: CGFloat(i)*self.emojiScrollView.width, y: 0, width: self.emojiScrollView.width, height: self.emojiScrollView.height)
            
            let view = creatCollectionViewFrame(frame)
            view.tag = 100+i
            self.emojiScrollView.addSubview(view)
            
            var totalNum = pageSize*(i+1)
            if pageSize*(i+1) > groupModel?.emojis?.count ?? 0 {
                totalNum = groupModel?.emojis?.count ?? 0
            }
            let arr = groupModel?.emojis![i*pageSize..<totalNum]
            let arr2 = Array(arr!) as [YXEmojiItemModel]
            pageEmojis.append(arr2)
        }

        emojiPageCont.numberOfPages = pageNum
        emojiPageCont.currentPage = 0
        emojiScrollView.contentOffset = CGPoint(x: 0, y: 0)
        
    }
    */
    
    func creatCollectionViewFrame(_ frame: CGRect, isLargeEmoji: Bool) -> UICollectionView {
//        var lineNum: CGFloat = 0
        var columnNum: CGFloat = 0
        var spacing: CGFloat = 0

        let layout = UICollectionViewFlowLayout()

        if isLargeEmoji {
//            lineNum = largeEmojiLineCount;
            columnNum = largeEmojiColumnCount;
            spacing = largeEmojiSpacing
            layout.minimumLineSpacing = 24
            layout.minimumInteritemSpacing = ceil((self.width - 48*columnNum - 24*2 ) / (columnNum-1))
            layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
            layout.itemSize = CGSize(width: 48, height: 48)

        }else {
            columnNum = smallEmojiColumnCount;
            spacing = smallEmojiSpacing
//            layout.minimumLineSpacing = spacing
//            layout.minimumInteritemSpacing = spacing
//            layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
//            layout.itemSize = CGSize(width: 48, height: 48)
//            let width = (frame.size.width-(columnNum+1)*spacing)/(columnNum)
//            layout.itemSize = CGSize(width: width, height: width)
            layout.minimumLineSpacing = 24
            layout.minimumInteritemSpacing = ceil((self.width - 34*columnNum - 24*2 ) / (columnNum-1))
            layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
            layout.itemSize = CGSize(width: 34, height: 34)
        }
        
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: frame, collectionViewLayout: layout)
        view.isScrollEnabled = true
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .clear
        view.register(UINib(nibName: "YXEmojiViewCell", bundle: nil), forCellWithReuseIdentifier: "YXEmojiViewCell")
        return view
    }
    
}


// MARK: Delegate

extension YXEmojiContentView {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let arr = pageEmojis[collectionView.tag - 100]
        return arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YXEmojiViewCell", for: indexPath) as! YXEmojiViewCell
        let arr = pageEmojis[collectionView.tag - 100]
        let model = arr[indexPath.row]
        cell.itemImgV.image = model.image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let arr = pageEmojis[collectionView.tag - 100]
        let model = arr[indexPath.row]
        // 点击展示表情包内容
        self.clickEmojiItemBlock?(model)
    }
    
}

extension YXEmojiContentView {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == emojiScrollView {
            let page = scrollView.contentOffset.x/self.width;
    //        self.emojiPageCont.currentPage = Int(page);
            self.updateTabbarItemClosure?(Int(page))
        }
    }
}
