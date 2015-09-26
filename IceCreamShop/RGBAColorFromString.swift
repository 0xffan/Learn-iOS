//
//  RGBAColorFromString.swift
//  IceCreamShop
//
//  Created by xfan on 23/07/15.
//  Copyright © 2015年 ixfan. All rights reserved.
//

import UIKit

func RGB(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
	return RGBA(red, green: green, blue: blue, alpha: 1.0)
}

func RGBA(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
	return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
}

extension UIColor {
	class func RGBAColorFromString(string: String?) -> UIColor? {
		guard let string = string else { return nil }
		
		var components = string.componentsSeparatedByString(",")
		
		if components.count == 3 {
			components.append("255")
		}
		
		guard components.count == 4 else { return nil }
		
		let red = CGFloat((NSNumberFormatter().numberFromString(components[0])?.floatValue)! / 255)
		let green = CGFloat((NSNumberFormatter().numberFromString(components[1])?.floatValue)! / 255)
		let blue = CGFloat((NSNumberFormatter().numberFromString(components[2])?.floatValue)! / 255)
		let alpha = CGFloat((NSNumberFormatter().numberFromString(components[3])?.floatValue)! / 255)
		
		return UIColor(red: red, green: green, blue: blue, alpha: alpha)
	}
}