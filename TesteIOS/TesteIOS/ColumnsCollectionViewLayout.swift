//
//  UnevenCollectionViewLayout.swift
//  TesteIOS
//
//  Created by Jorge Mendes on 26/05/16.
//  Copyright © 2016 amaris. All rights reserved.
//

import UIKit

protocol ColumnsCollectionViewLayoutDelegate {
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath , withWidth width:CGFloat) -> CGFloat
    func collectionView(collectionView: UICollectionView, heightForTitleAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
}

class ColumnsCollectionViewLayout: UICollectionViewLayout {

    private let horizontalCellMargin: CGFloat = 8.0
    private let verticalCellMargin: CGFloat = 10.0
    private let defaultCellWidth: CGFloat = 150.0
    
    internal var delegate: ColumnsCollectionViewLayoutDelegate!
    
    private var layoutAttributes: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat  = 0.0
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
    }
    
    override func prepareLayout() {
        if self.layoutAttributes.isEmpty {
            let numberOfColumns: Int = Int(floor(self.collectionView!.frame.width / self.defaultCellWidth))
            let columnWidth: CGFloat = contentWidth / CGFloat(numberOfColumns)
            
            var xOffset: [CGFloat] = []
            for column: Int in 0 ..< numberOfColumns {
                xOffset.append(CGFloat(column) * columnWidth)
            }
            
            var column: Int = 0
            var yOffset: [CGFloat] = [CGFloat](count: numberOfColumns, repeatedValue: 0)
            
            for item: Int in 0 ..< self.collectionView!.numberOfItemsInSection(0) {
                let indexPath: NSIndexPath = NSIndexPath(forItem: item, inSection: 0)
                
                let width: CGFloat = columnWidth - self.horizontalCellMargin * 2.0
                let photoHeight: CGFloat = self.delegate.collectionView(self.collectionView!, heightForPhotoAtIndexPath: indexPath, withWidth:width)
                let titleHeight: CGFloat = self.delegate.collectionView(self.collectionView!, heightForTitleAtIndexPath: indexPath, withWidth: width)
                let height: CGFloat = self.verticalCellMargin * 2.0 + photoHeight + titleHeight
                let frame: CGRect = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                let insetFrame: CGRect = CGRectInset(frame, self.horizontalCellMargin, self.verticalCellMargin)
                
                let attributes: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.frame = insetFrame
                self.layoutAttributes.append(attributes)
                
                self.contentHeight = max(self.contentHeight, CGRectGetMaxY(frame))
                yOffset[column] = yOffset[column] + height
                column = column >= (numberOfColumns - 1) ? 0 : column + 1
            }
        }
    }
    
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: self.contentWidth, height: self.contentHeight)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes: [UICollectionViewLayoutAttributes] = []
        self.layoutAttributes.forEach {
            if CGRectIntersectsRect($0.frame, rect) {
                attributes.append($0)
            }
        }
        return attributes
    }
    
    internal func resetLayout() {
        self.layoutAttributes.removeAll()
    }
    
}
