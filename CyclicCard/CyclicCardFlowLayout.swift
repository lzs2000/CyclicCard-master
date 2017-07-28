//
//  CyclicCardFlowLayout.swift
//  CyclicCard
//
//  Created by Tony on 17/1/11.
//  Copyright © 2017年 Tony. All rights reserved.
//

import UIKit

class CyclicCardFlowLayout: UICollectionViewFlowLayout {
    
    
    let ActiveDistance : CGFloat = 170 //垂直缩放除以系数
    let ScaleFactor : CGFloat = 0.5     //缩放系数  越大缩放越大
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0.0, width:  self.collectionView!.bounds.size.width, height: self.collectionView!.bounds.size.height)
        // 目标区域中包含的cell
        let attriArray = super.layoutAttributesForElements(in: targetRect)! as [UICollectionViewLayoutAttributes]
        // collectionView落在屏幕中点的x坐标
        let horizontalCenterX = proposedContentOffset.x + (self.collectionView!.bounds.width / 2.0)
        var offsetAdjustment = CGFloat(MAXFLOAT)
        for layoutAttributes in attriArray {
            let itemHorizontalCenterX = layoutAttributes.center.x
            // 找出离中心点最近的
            if(abs(itemHorizontalCenterX-horizontalCenterX) < abs(offsetAdjustment)){
                offsetAdjustment = itemHorizontalCenterX-horizontalCenterX
            }
        }
        //返回collectionView最终停留的位置
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let array = super.layoutAttributesForElements(in: rect)
        var visibleRect = CGRect()
        visibleRect.origin = self.collectionView!.contentOffset
        visibleRect.size = self.collectionView!.bounds.size
        
        for attributes in array!{
            let distance = visibleRect.midX - attributes.center.x
            let normalizedDistance = abs(distance/ActiveDistance)
            let zoom = 1 - ScaleFactor * normalizedDistance
            print(zoom)
            if zoom < 0.7 {
               
                attributes.transform3D = CATransform3DMakeScale(0.7, 0.7, 1.0)
            } else {
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0)
            }
            attributes.zIndex = 1

        }
        return array
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        //滑动放大缩小  需要实时刷新layout
        return true
    }
}
