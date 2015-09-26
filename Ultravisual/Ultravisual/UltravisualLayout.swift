//
//  UltravisualLayout.swift
//  Ultravisual
//
//  Created by xfan on 20/08/15.
//  Copyright © 2015年 ixfan. All rights reserved.
//

import UIKit

struct UltravisualLayoutConstant {
	struct Cell {
		static let standardHeight: CGFloat = 100
		static let featuredHeight: CGFloat = 280
	}
}

class UltravisualLayout: UICollectionViewLayout {
	
	// MARK: Properties and Variables
	/* The amount the user needs to scroll before the featured cell changes */
	let dragOffset: CGFloat = 180
	
	var cache = [UICollectionViewLayoutAttributes]()
	
	var featuredItemIndex: Int {
		return max(0, Int(collectionView!.contentOffset.y / dragOffset))
	}
	
	/* Returns a value between 0 and 1 that represents how close the next cell is to becoming the featured cell */
	var nextItemPercentageOffset: CGFloat {
		return (collectionView!.contentOffset.y / dragOffset) - CGFloat(featuredItemIndex)
	}
	
	/* Returns the width of the collection view */
	var width: CGFloat {
		return collectionView!.bounds.width
	}
	
	/* Returns the height of the collection view */
	var height: CGFloat {
		return collectionView!.bounds.height
	}
	
	var numberOfItems: Int {
		return collectionView!.numberOfItemsInSection(0)
	}
	
	// MARK: UICollectionViewLayout
	
	override func collectionViewContentSize() -> CGSize {
		let contentHeight = (CGFloat(numberOfItems) * dragOffset) + (height - dragOffset)
		return CGSize(width: width, height: contentHeight)
	}
	
	override func prepareLayout() {
		cache.removeAll(keepCapacity: false)
		
		let standardHeight = UltravisualLayoutConstant.Cell.standardHeight
		let featuredHeight = UltravisualLayoutConstant.Cell.featuredHeight
		
		var frame = CGRectZero
		var y: CGFloat = 0
		
		for item in 0..<numberOfItems {
			
			// 1. Create an index path to the current cell, then get its current attributes.
			let indexPath = NSIndexPath(forItem: item, inSection: 0)
			let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
			
			// 2. Prepare the cell to move up or down. Since the majority of cells will not be featured — there are many more standard cells than the single featured cells — it defaults to the standardHeight.
			attributes.zIndex = item
			var height = standardHeight
			
			// 3. Determine the current cell’s status — featured, next or standard. In the case of the latter, you do nothing.
			if indexPath.item == featuredItemIndex {
				// 4. If the cell is currently in the featured cell position, calculate the yOffset and use that to derive the new y value for the cell. After that, you set the cell’s height to be the featured height.
				let yOffset = standardHeight * nextItemPercentageOffset
				y = collectionView!.contentOffset.y - yOffset
				height = featuredHeight
			} else if indexPath.item == (featuredItemIndex + 1) && indexPath.item != numberOfItems {
				// 5. If the cell is next in line, you start by calculating the largest y could be (in this case, larger than the featured cell) and combine that with a calculated height to end up with the correct value of y, which is 280.0 — the height of the featured cell.
				let maxY = y + standardHeight
				height = standardHeight + max((featuredHeight - standardHeight) * nextItemPercentageOffset, 0)
				y = maxY - height
			}
			
			// 6. Lastly, the loop sets some common elements for each cell, including creating the right frame based upon the if condition above, setting the attributes to what was just calculated, and updating the cache values. The very last step is to update y so that it’s at the bottom of the last calculated cell, so you can move down the list of cells efficiently.
			frame = CGRect(x: 0, y: y, width: width, height: height)
			attributes.frame = frame
			cache.append(attributes)
			y = CGRectGetMaxY(frame)
		}
		
	}
	
	/* Return all attributes in the cache whose frame intersects with the rect passed to the method */
	override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		var layoutAttributes = [UICollectionViewLayoutAttributes]()
		for attribute in cache {
			if CGRectIntersectsRect(attribute.frame, rect) {
				layoutAttributes.append(attribute)
			}
		}
		return layoutAttributes
	}
	
	/* Return true so that the layout is continuously invalidated as the user scrolls */
	override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
		return true
	}
	
	override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
		let itemIndex = round(proposedContentOffset.y / dragOffset)
		let yOffset = itemIndex * dragOffset
		return CGPoint(x: 0, y: yOffset)
	}
}