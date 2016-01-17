//
//  PetCardStore.swift
//  GuessThePet
//
//  Created by Wei Jun Fan on 16/1/17.
//  Copyright © 2016年 ixfan. All rights reserved.
//

import UIKit

struct PetCardStore {
	static func defaultPets() -> [PetCard] {
		return parsePets();
	}

	private static func parsePets() -> [PetCard] {
		let filePath = NSBundle.mainBundle().pathForResource("Pets", ofType: "plist")!
		let dictionary = NSDictionary(contentsOfFile: filePath)!
		let petData = dictionary["Pets"] as! [[String:String]]

		let pets = petData.map { (dict) -> PetCard in
			return PetCard(name: dict["name"]!, description: dict["description"]!, image: UIImage(named: dict["image"]!)!)
		}

		return pets
	}
}