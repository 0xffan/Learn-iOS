//
//  InspirationsCollectionViewController.swift
//  Ultravisual
//
//  Created by xfan on 19/08/15.
//  Copyright © 2015年 ixfan. All rights reserved.
//

import UIKit

class InspirationsCollectionViewController: UICollectionViewController {
	
	let inspirations = Inspiration.allInspirations()
	let colors = UIColor.palette()
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return UIStatusBarStyle.LightContent
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		if let patternImage = UIImage(named: "Pattern") {
			view.backgroundColor = UIColor(patternImage: patternImage)
		}
		collectionView!.backgroundColor = UIColor.clearColor()
		collectionView!.decelerationRate = UIScrollViewDecelerationRateFast
		
//		let layout = collectionViewLayout as! UICollectionViewFlowLayout
//		layout.itemSize = CGSize(width: CGRectGetWidth(collectionView!.bounds), height: 100)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension InspirationsCollectionViewController {
	
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return inspirations.count
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("InspirationCell", forIndexPath: indexPath) as! InspirationCell
		cell.inspiration = inspirations[indexPath.item]
		return cell
	}
	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let layout = collectionViewLayout as! UltravisualLayout
		let offset = layout.dragOffset * CGFloat(indexPath.item)
		if collectionView.contentOffset.y != offset {
			collectionView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
		}
	}
}