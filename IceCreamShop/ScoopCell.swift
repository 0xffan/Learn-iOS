//
//  ScoopCell.swift
//  IceCreamShop
//
//  Created by xfan on 23/07/15.
//  Copyright © 2015年 ixfan. All rights reserved.
//

import UIKit

class ScoopCell: UICollectionViewCell {
	
	override func awakeFromNib() {
		super.awakeFromNib()
		layer.cornerRadius = 10.0
	}
	
	// MARK: Outlets
	
	@IBOutlet weak var textLabel: UILabel!
	@IBOutlet weak var scoopView: ScoopView!
}

extension ScoopCell: FlavorAdapter {
	func updateWithFlavor(flavor: Flavor) {
		scoopView?.topColor = flavor.topColor
		scoopView?.bottomColor = flavor.bottomColor
		scoopView?.setNeedsDisplay()
		
		textLabel?.text = flavor.name
	}
}
