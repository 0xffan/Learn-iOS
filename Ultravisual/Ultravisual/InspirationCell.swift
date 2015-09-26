//
//  InspirationCell.swift
//  Ultravisual
//
//  Created by xfan on 20/08/15.
//  Copyright © 2015年 ixfan. All rights reserved.
//

import UIKit

class InspirationCell: UICollectionViewCell {
	
	@IBOutlet private weak var imageView: UIImageView!
	@IBOutlet private weak var imageCoverView: UIView!
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var timeAndRoomLabel: UILabel!
	@IBOutlet private weak var speakerLabel: UILabel!
	
	var inspiration: Inspiration? {
		didSet {
			if let inspiration = self.inspiration {
				imageView?.image = inspiration.backgroundImage
				titleLabel?.text = inspiration.title
				timeAndRoomLabel?.text = inspiration.roomAndTime
				speakerLabel?.text = inspiration.speaker
			}
		}
	}
	
	override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
		super.applyLayoutAttributes(layoutAttributes)
		
		let standardHeight = UltravisualLayoutConstant.Cell.standardHeight
		let featuredHeight = UltravisualLayoutConstant.Cell.featuredHeight
		
		// Calculate the delta of the cell as it’s moving to figure out how much to adjust the alpha in the following step.
		let delta = 1 - ((featuredHeight - CGRectGetHeight(frame)) / (featuredHeight - standardHeight))
		
		// Based on the range constants, update the cell’s alpha based on the delta value.
		let minAlpha: CGFloat = 0.2
		let maxAlpha: CGFloat = 0.75
		imageCoverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
		
		let scale = max(delta, 0.5)
		titleLabel.transform = CGAffineTransformMakeScale(scale, scale)
		timeAndRoomLabel.alpha = delta
		speakerLabel.alpha = delta
	}
    
}
