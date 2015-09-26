//
//  UIImage+Decompression.swift
//  Ultravisual
//
//  Created by xfan on 19/08/15.
//  Copyright © 2015年 ixfan. All rights reserved.
//

import UIKit

extension UIImage {
	var decompressedImage: UIImage {
		UIGraphicsBeginImageContextWithOptions(size, true, 0)
		drawAtPoint(CGPointZero)
		let decompressedImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return decompressedImage
	}
}