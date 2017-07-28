//
//  MainTableTableViewController.swift
//  CyclicCard
//
//  Created by 刘璐璐 on 2017/7/13.
//  Copyright © 2017年 Tony. All rights reserved.
//

import UIKit

class MainTableViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    let headImgView : UIImageView = UIImageView()
    let bgview = UIView()
    var collectionView : UICollectionView!
    let showLabel = UILabel()
    let currentLabel = UILabel()
    let scorllview = UIScrollView()
    
    
    var offsetStartY:CGFloat = 0
    var offsetEndY:CGFloat = 0
    
    let groupCount = 100 // 制造100组数据，给无限滚动提供足够多的数据，嫌少可以200，1000。。。
    var imageArr = [String]() // 图片数组
    var indexArr = [Int]() // 存储图片下标，解决制造100组图片数据占用过大内存问题
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setupUI()
        
        // 设置数据源
        imageArr = ["num_1", "num_2", "num_3", "num_4", "num_5"]
        for _ in 0 ..< groupCount {
            for j in 0 ..< imageArr.count {
                indexArr.append(j)
            }
        }
        
        // 定位到 第50组(中间那组)
        collectionView.scrollToItem(at: NSIndexPath.init(item: groupCount / 2 * imageArr.count, section: 0) as IndexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
 
    }
    
    func setupUI() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.headImgView.frame = CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        self.headImgView.image = UIImage.init(named: "eee")
        self.headImgView.contentMode = .scaleAspectFill
        
        self.scorllview.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        self.scorllview.contentSize = CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT * 3)
        self.scorllview.delegate = self
        self.view.addSubview(self.scorllview)
        
        self.scorllview.addSubview(self.headImgView)
        self.headImgView.isUserInteractionEnabled = true
        automaticallyAdjustsScrollViewInsets = false
        
        bgview.frame = CGRect(x: 0, y: SCREEN_HEIGHT - 120, width: SCREEN_WIDTH, height: FIT_SCREEN_HEIGHT(150))
        bgview.backgroundColor = UIColor.clear
        self.view.addSubview(bgview)
        
        setupCollection()
        
        
    }
    
    func setupCollection() {
        
        let padding = FIT_SCREEN_WIDTH(10)
        
        let layout = CyclicCardFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        layout.sectionInset = UIEdgeInsetsMake(padding, 0, padding, 0)
        let itemW = 60
        layout.itemSize = CGSize(width: itemW, height: itemW)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 120), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.collectionViewLayout = layout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self as UICollectionViewDelegate
        collectionView.dataSource = self as UICollectionViewDataSource
        collectionView.register(CyclicCardCell.self, forCellWithReuseIdentifier: NSStringFromClass(CyclicCardCell.self))
        bgview.addSubview(self.collectionView)
        
       //tableView.isPagingEnabled = true
    }
    
    
    // MARK:- CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return indexArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CyclicCardCell.self), for: indexPath) as! CyclicCardCell
        
        let index = indexArr[indexPath.row]
        cell.index = index
        cell.cardImgView.image = UIImage(named: imageArr[index])
        // cell.cardNameLabel.text = "奔跑吧，小蜗牛~"
        
        return cell
    }
    
    func fade(imageView: UIImageView, toImage: UIImage) {
        UIView.transition(with: imageView, duration: 1.0, options: .transitionCrossDissolve, animations: { 
            imageView.image = toImage
        }, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
           let index = indexArr[indexPath.row]
         self.fade(imageView: self.headImgView, toImage: UIImage(named: "\(imageArr[index])")! )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CyclicCardCell
        print("点击第\(cell.index + 1)张图片")
        currentLabel.text = "点击第\(cell.index + 1)张图片"
    }
    
     func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pointInView = view.convert(collectionView.center, to: collectionView)
        let indexPathNow = collectionView.indexPathForItem(at: pointInView)
        let index = (indexPathNow?.row ?? 0) % imageArr.count
        let curIndexStr = String(format: "滚动至第%d张", index + 1)
        print(curIndexStr)
        showLabel.text = curIndexStr
    }
    
}
    




extension MainTableViewController : UIScrollViewDelegate {
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
       // NSObject.cancelPreviousPerformRequests(withTarget: self)
        let offsetY = scrollView.contentOffset.y
        print("__________________")
        print(offsetY)
        if offsetY < SCREEN_HEIGHT / 4 {
            UIView.animate(withDuration: 0.3, animations: { 
                self.headImgView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
                self.scorllview.contentOffset = CGPoint(x: 0, y: 0)
                self.collectionView.isHidden = false
                self.collectionView.alpha = 1
            })
        } else if offsetY < SCREEN_HEIGHT / 2 {
            UIView.animate(withDuration: 0.3, animations: { 
                self.headImgView.frame = CGRect(x: 0, y: SCREEN_HEIGHT / 2, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
                self.scorllview.contentOffset = CGPoint(x: 0, y: SCREEN_HEIGHT / 2)
                self.collectionView.isHidden = true
                self.collectionView.alpha = 0
            })
            
        }
        
    }
    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        NSObject.cancelPreviousPerformRequests(withTarget: self)
//        self.perform(Selector("scrollViewDidEndScrollingAnimation: willDecelerate: "), with: nil, afterDelay: 0.5)
        let offsetY = scrollView.contentOffset.y

        if offsetY > 0 {
            
            
            if offsetY > 100 {
                self.collectionView.isHidden = true
            } else {
                self.collectionView.isHidden = false
                UIView.animate(withDuration: 0.3, animations: {
                    self.collectionView.alpha = (100 - offsetY)/100
                    if (self.collectionView.alpha < 0.1) {
                        self.collectionView.alpha = 0
                        
                    }
                })
            }
            
        }
         headImgView.frame = CGRect(x: 0, y: offsetY, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - offsetY)
    }
    
   
    
    
    
    // MARK: - Table view data source
   }
