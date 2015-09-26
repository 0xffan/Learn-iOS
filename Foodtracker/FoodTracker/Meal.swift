//
//  Meal.swift
//  FoodTracker
//
//  Created by xfan on 14/06/15.
//  Copyright © 2015年 ixfan. All rights reserved.
//

import UIKit

final class Meal: NSObject, NSCoding {
	
	// MARK: Properties
	var name: String
	var photo: UIImage?
	var rating: Int
	
	// MARK: Archiving Paths
	static let DocumentDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
	static let ArchiveURL = DocumentDirectory.URLByAppendingPathComponent("meals")
	
	// MARK: Initialization
	init?(name: String, photo: UIImage?, rating: Int) {
		// Initialize stored properties.
		self.name = name
		self.photo = photo
		self.rating = rating
		
		super.init()
		
		// Initialization should fail if there is no name or if the rating is negative.
		if name.isEmpty || rating < 0 {
			return nil
		}
	}
	
	// MARK: Types
	struct PropertyKey {
		static let nameKey = "name"
		static let photoKey = "photo"
		static let ratingKey = "rating"
	}
	
	// MARK: NSCoding
	func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
		aCoder.encodeObject(photo, forKey: PropertyKey.photoKey)
		aCoder.encodeInteger(rating, forKey: PropertyKey.ratingKey)
	}
	
	required convenience init?(coder aDecoder: NSCoder) {
		let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
		let photo = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as? UIImage
		let rating = aDecoder.decodeIntegerForKey(PropertyKey.ratingKey)
		
		// Must call designated initilizer.
		self.init(name: name, photo: photo, rating: rating)
	}
}