//
//  PickFlavorDataSource.swift
//  IceCreamShop
//
//  Created by xfan on 02/08/15.
//  Copyright © 2015年 ixfan. All rights reserved.
//

import UIKit

class PickFlavorDataSource: NSObject, UICollectionViewDataSource {
	
	// MARK: Identifiers
	
	private struct Identifiers {
		static let ScoopCell = "ScoopCell"
	}
	
	// MARK: Instance Variables
	
	var flavors = [Flavor]()
	
	// MARK: Outlets
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	// MARK: UICollectionViewDataSource
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return flavors.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		return scoopCellAtIndexPath(indexPath)
	}
	
	private func scoopCellAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Identifiers.ScoopCell, forIndexPath: indexPath) as! ScoopCell
		configureScoopCell(cell, atIndexPath: indexPath)
		return cell
	}
	
	private func configureScoopCell(cell: ScoopCell, atIndexPath indexPath: NSIndexPath) {
		let flavor = flavors[indexPath.row]
		cell.updateWithFlavor(flavor)
	}
}