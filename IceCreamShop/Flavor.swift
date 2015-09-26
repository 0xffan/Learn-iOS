//
//  Flavor.swift
//  IceCreamShop
//
//  Created by xfan on 23/07/15.
//  Copyright © 2015年 ixfan. All rights reserved.
//

import UIKit

struct Flavor {
	
	// MARK: Instance Variables
	
	let name: String
	let topColor: UIColor
	let bottomColor: UIColor
	
	// MARK: Static Methods
	
	static func vanilla() -> Flavor {
		return Flavor(name: "Vanilla", topColor: UIColor.RGBAColorFromString("251,248,236")!, bottomColor: UIColor.RGBAColorFromString("230,215,171")!)
	}
	
	static func chocolate() -> Flavor {
		return Flavor(name: "Chocolate", topColor: UIColor.RGBAColorFromString("203,140,58")!, bottomColor: UIColor.RGBAColorFromString("107,46,11")!)
	}
	
	// MARK: Initializers
	
	init(name: String, topColor: UIColor, bottomColor: UIColor) {
		self.name = name
		self.topColor = topColor
		self.bottomColor = bottomColor
	}
	
	init?(dictionary: [String:String]) {
		guard let topColor = UIColor.RGBAColorFromString(dictionary["topColor"]) else { return nil }
		guard let bottomColor = UIColor.RGBAColorFromString(dictionary["bottomColor"]) else { return nil }
		guard let name = dictionary["name"] else { return nil }
		
		self.name = name
		self.topColor = topColor
		self.bottomColor = bottomColor
	}
}

protocol FlavorAdapter {
	func updateWithFlavor(flavor: Flavor)
}
