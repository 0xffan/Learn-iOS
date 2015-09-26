//
//  Inspiration.swift
//  Ultravisual
//
//  Created by xfan on 19/08/15.
//  Copyright © 2015年 ixfan. All rights reserved.
//

import UIKit

class Inspiration: Session {
	
	class func allInspirations() -> [Inspiration] {
		var inspirations = [Inspiration]()
		
		guard let URL = NSBundle.mainBundle().URLForResource("Inspirations", withExtension: "plist") else { return inspirations }
		guard let tutorialsFromPlist = NSArray(contentsOfURL: URL) else { return inspirations }
		
		for directory in tutorialsFromPlist {
			let inspiration = Inspiration(directory: directory as! [String: String])
			inspirations.append(inspiration)
		}
		
		return inspirations
	}
}