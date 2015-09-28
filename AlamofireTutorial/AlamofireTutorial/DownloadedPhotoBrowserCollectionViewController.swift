//
//  DownloadedPhotoBrowserCollectionViewController.swift
//  AlamofireTutorial
//
//  Created by Wei Jun Fan on 26/09/15.
//  Copyright © 2015年 ixfan. All rights reserved.
//

import UIKit

class DownloadedPhotoBrowserCollectionViewController: UICollectionViewController {
	
	var downloadedPhotoURLs: [NSURL]?
	let downloadedPhotoBrowserCellIdentifier = "DownloadedPhotoBrowserCell"

	// MARK: Life Cycle
	
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: true)
		
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = CGSize(width: view.frame.width, height: 200.0)
		collectionView?.collectionViewLayout = layout
		
		// Register cell classes
		self.collectionView!.registerClass(DownloadedPhotoBrowserCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: downloadedPhotoBrowserCellIdentifier)
		
		navigationController?.title = "Downloads"
    }

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]

		if let urls = try? NSFileManager.defaultManager().contentsOfDirectoryAtURL(directoryURL, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions(rawValue: 0)) {
			downloadedPhotoURLs = urls
			collectionView?.reloadData()
		}
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return downloadedPhotoURLs?.count ?? 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(downloadedPhotoBrowserCellIdentifier, forIndexPath: indexPath) as! DownloadedPhotoBrowserCollectionViewCell
    
        // Configure the cell
		let localFileData = NSFileManager.defaultManager().contentsAtPath(downloadedPhotoURLs![indexPath.item].path!)
		let image = UIImage(data: localFileData!, scale: UIScreen.mainScreen().scale)
		cell.imageView.image = image
    
        return cell
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

class DownloadedPhotoBrowserCollectionViewCell: UICollectionViewCell {
	let imageView = UIImageView()
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(imageView)
		imageView.frame = bounds
		imageView.contentMode = .ScaleAspectFit
	}
}