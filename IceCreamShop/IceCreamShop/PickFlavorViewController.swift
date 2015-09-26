//
//  PickFlavorViewController.swift
//  IceCreamShop
//
//  Created by xfan on 23/07/15.
//  Copyright © 2015年 ixfan. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class PickFlavorViewController: UIViewController, UICollectionViewDelegate {
	
	// MARK: Instance Variables
	
	var flavors: [Flavor] = [] {
		didSet {
			pickFlavorDataSource?.flavors = self.flavors
		}
	}
	
	private var pickFlavorDataSource: PickFlavorDataSource? {
		return collectionView?.dataSource as? PickFlavorDataSource
	}
	
	private let flavorFactory = FlavorFactory()
	
	// MARK: Outlets
	@IBOutlet weak var contentView: UIView!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var iceCreamView: IceCreamView!
	@IBOutlet weak var label: UILabel!
	
	// MARK: View Lifecycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
		collectionView?.delegate = self
		loadFlavors()
    }
	
	private func loadFlavors() {
		// Implement this
		let urlString = "http://www.raywenderlich.com/downloads/Flavors.plist"
		
		showingLoadingHUD()
		
		Alamofire.request(.GET, urlString, encoding: .PropertyList(.XMLFormat_v1_0, 0))
			.responsePropertyList { request, response, result in
				
				self.hideLoadingHUD()
			
				if result.isFailure {
					print("Error: \(result.debugDescription)")
				} else if let array = result.value as? [[String: String]] {
					if array.isEmpty {
						print("No falvors were found!")
					} else {
						self.flavors = self.flavorFactory.flavorsFromDictionaryArray(array)
						self.collectionView.reloadData()
						self.selectFirstFlavor()
					}
				}
		}
	}
	
	private func showingLoadingHUD() {
		let hud = MBProgressHUD.showHUDAddedTo(contentView, animated: true)
		hud.labelText = "Loading..."
	}
	
	private func hideLoadingHUD() {
		MBProgressHUD.hideAllHUDsForView(contentView, animated: true)
	}

	private func selectFirstFlavor() {
		if let flavor = flavors.first {
			updateWithFlavor(flavor)
		}
	}
	
	// MARK: UICollectionViewDelegate
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let flavor = flavors[indexPath.row]
		updateWithFlavor(flavor)
	}
	
	// MARK: Internal
	
	private func updateWithFlavor(flavor: Flavor) {
		iceCreamView.updateWithFlavor(flavor)
		label.text = flavor.name
	}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
