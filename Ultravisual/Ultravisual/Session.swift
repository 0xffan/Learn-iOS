//
//  Session.swift
//  Ultravisual
//
//  Created by xfan on 19/08/15.
//  Copyright © 2015年 ixfan. All rights reserved.
//

import UIKit

class Session {
	var title: String
	var speaker: String
	var room: String
	var time: String
	var backgroundImage: UIImage
	
	var roomAndTime: String {
		return "\(room) • \(time)"
	}
	
	init(title: String, speaker: String, room: String, time: String, backgroundImage: UIImage) {
		self.title = title
		self.speaker = speaker
		self.room = room
		self.time = time
		self.backgroundImage = backgroundImage
	}
	
	convenience init(directory: [String: String]) {
		let title = directory["Title"]
		let speaker = directory["Speaker"]
		let room = directory["Room"]
		let time = directory["Time"]
		let backgroundName = directory["Background"]
		let backgroundImage = UIImage(named: backgroundName!)
		
		self.init(title: title!, speaker: speaker!, room: room!, time: time!, backgroundImage: backgroundImage!.decompressedImage)
		
	}
}