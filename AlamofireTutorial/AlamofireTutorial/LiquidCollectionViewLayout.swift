//
//  LiquidCollectionViewLayout.swift
//  AlamofireTutorial
//
//  Created by Wei Jun Fan on 30/09/15.
//  Copyright © 2015年 ixfan. All rights reserved.
//

import UIKit

protocol LiquidCollectionViewLayoutDelegate: class {
	func collectionView(collectionView: UICollectionView?, heightForPhotoAtIndexPath indexPath: NSIndexPath, width: CGFloat) -> CGFloat
}

class LiquidCollectionViewLayout: UICollectionViewLayout {
	
	private var contentHeight: CGFloat = 0.0
	private var contentWidth: CGFloat {
		let contentInsets = collectionView!.contentInset
		return collectionView!.bounds.width - contentInsets.left - contentInsets.right
	}
	private var xOffset = [CGFloat]()
	private var yOffset = [CGFloat]()
	
	let cellPadding: CGFloat = 5.0
	var numberOfColumns = 2
	
	private var layoutAttributesCache = [UICollectionViewLayoutAttributes]()
	
	weak var delegate: LiquidCollectionViewLayoutDelegate!
	
	// MARK: Collection View Layout
	
	override func prepareLayout() {
		// guard layoutAttributesCache.isEmpty else { return }
		
		let cellWidth = (contentWidth - CGFloat(numberOfColumns - 1) * cellPadding) / CGFloat(numberOfColumns)
		
		xOffset = [CGFloat]()
		yOffset = [CGFloat](count: numberOfColumns, repeatedValue: 0.0)

		for column in 0..<numberOfColumns {
			xOffset.append(cellWidth * CGFloat(column) + CGFloat(column) * cellPadding)
		}
			
		layoutAttributesCache.removeAll()
		
		var column = 0
		
		for item in 0..<collectionView!.numberOfItemsInSection(0) {
			
			let indexPath = NSIndexPath(forItem: item, inSection: 0)
			
			let photoHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath, width: cellWidth)
			let cellHeight = photoHeight
			let frame = CGRect(x: xOffset[column], y: yOffset[column], width: cellWidth, height: cellHeight)

			let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
			attributes.frame = frame
			layoutAttributesCache.append(attributes)
			
			contentHeight = max(contentHeight, CGRectGetMaxY(frame) + cellPadding)
			yOffset[column] = yOffset[column] + cellHeight + cellPadding
			
			column = column >= (numberOfColumns - 1) ? 0 : ++column
		}
		
	}
	
	override func collectionViewContentSize() -> CGSize {
		return CGSize(width: contentWidth, height: contentHeight)
	}
	
	override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		
		var layoutAttributes = [UICollectionViewLayoutAttributes]()
		
		for attributes in layoutAttributesCache where attributes.frame.intersects(rect) {
			layoutAttributes.append(attributes)
		}
		
		return layoutAttributes
	}
	
	override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
		return layoutAttributesCache[indexPath.item]
	}

}
