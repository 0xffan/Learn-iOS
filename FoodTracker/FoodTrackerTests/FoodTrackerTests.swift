//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by xfan on 14/06/15.
//  Copyright © 2015年 ixfan. All rights reserved.
//

import XCTest

class FoodTrackerTests: XCTestCase {
	
	// MARK: FoodTracker Test
	
	// Tests to confirm that the Meal initializer returns when no name or a negative rating is provided
	func testMealInitialization() {
		// Success case
		let meal = Meal(name: "Newest meal", photo: nil, rating: 5)
		XCTAssertNotNil(meal)
		
		// Failure case
		let noName = Meal(name: "", photo: nil, rating: 5)
		XCTAssertNil(noName, "Empty name is invalid")
		
		let badRating = Meal(name: "Really bad rating", photo: nil, rating: -1)
		XCTAssertNil(badRating, "Negative ratings are invalid, be positive")
	}
		
}
