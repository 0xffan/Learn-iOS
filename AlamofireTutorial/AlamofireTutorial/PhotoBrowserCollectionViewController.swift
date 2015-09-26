//
//  PhotoBrowserCollectionViewController.swift
//  AlamofireTutorial
//
//  Created by Wei Jun Fan on 22/09/15.
//  Copyright © 2015年 ixfan. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PhotoBrowserCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	
	var photos = NSMutableOrderedSet()
	
	let refreshControl = UIRefreshControl()
	
	let PhotoBrowserCellIdentifier = "PhotoBrowserCell"
	let PhotoBrowserFooterViewIdentifier = "PhotoBrowserFooterView"

	// MARK: Life-cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
		if segue.identifier == "ShowPhoto" {
			(segue.destinationViewController as! PhotoViewerViewController).photoID = sender!.integerValue
			(segue.destinationViewController as! PhotoViewerViewController).hidesBottomBarWhenPushed = true
		}
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoBrowserCellIdentifier, forIndexPath: indexPath) as! PhotoBrowserCollectionViewCell
    
        return cell
    }
	
	override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
		return collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: PhotoBrowserFooterViewIdentifier, forIndexPath: indexPath) as! PhotoBrowserCollectionViewLoadingCell
	}
	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		performSegueWithIdentifier("ShowPhoto", sender: (self.photos.objectAtIndex(indexPath.item) as! PhotoInfo).id)
	}
	
	// MARK: Helper
	
	func setupView() {
		navigationController?.setNavigationBarHidden(false, animated: true)
		
		let layout = UICollectionViewFlowLayout()
		let itemWidth = (view.bounds.size.width - 2) / 3
		
		layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
		layout.minimumInteritemSpacing = 1.0
		layout.minimumLineSpacing = 1.0
		layout.footerReferenceSize = CGSize(width: collectionView!.bounds.size.width, height: 100.0)
		
		collectionView!.collectionViewLayout = layout
		
		navigationItem.title = "Featured"
		
		collectionView!.registerClass(PhotoBrowserCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: PhotoBrowserCellIdentifier)
		collectionView!.registerClass(PhotoBrowserCollectionViewLoadingCell.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: PhotoBrowserFooterViewIdentifier)
		
		refreshControl.tintColor = UIColor.whiteColor()
		refreshControl.addTarget(self, action: "handleRefresh", forControlEvents: .ValueChanged)
		collectionView!.addSubview(refreshControl)
	}
	
	func handleRefresh() {
		
	}

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}

class PhotoBrowserCollectionViewCell: UICollectionViewCell {
	let imageView = UIImageView()
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = UIColor(white: 0.1, alpha: 1.0)
		
		imageView.frame = bounds
		addSubview(imageView)
	}
}

class PhotoBrowserCollectionViewLoadingCell: UICollectionReusableView {
	let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		spinner.startAnimating()
		spinner.center = center
		addSubview(spinner)
	}
}
