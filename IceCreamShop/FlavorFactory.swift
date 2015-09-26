//
//  FlavorFactory.swift
//  IceCreamShop
//
//  Created by xfan on 25/07/15.
//  Copyright © 2015年 ixfan. All rights reserved.
//

import Foundation

class FlavorFactory {
	func flavorsFromPlistNamed(plistname: String, bundle: NSBundle = NSBundle.mainBundle()) -> [Flavor]? {
		let path = bundle.pathForResource(plistname, ofType: "plist")!
		let data = NSData(contentsOfFile: path)!
		
		do {
			let array = try NSPropertyListSerialization.propertyListWithData(data, options: NSPropertyListMutabilityOptions.Immutable, format: nil) as! [[String:String]]
			return flavorsFromDictionaryArray(array)
		} catch {
			return nil
		}
	}
	
	func flavorsFromDictionaryArray(array: [[String:String]]) -> [Flavor] {
		var flavors: [Flavor] = []
		
		for dictionary in array {
			if let flavor = Flavor(dictionary: dictionary) {
				flavors.append(flavor)
			}
		}
		
		return flavors
	}
}