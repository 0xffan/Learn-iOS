//
//  PhotoBrowserCollectionViewController.swift
//  AlamofireTutorial
//
//  Created by Wei Jun Fan on 22/09/15.
//  Copyright © 2015年 ixfan. All rights reserved.
//

import UIKit
import Alamofire

class PhotoBrowserCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, LiquidCollectionViewLayoutDelegate {
	
	var photos = NSMutableOrderedSet()
	
	let refreshControl = UIRefreshControl()
	
	let imageCache = NSCache()
	
	var populatingPhotos = false
	var currentPage = 1
	
	let PhotoBrowserCellIdentifier = "PhotoBrowserCell"
	let PhotoBrowserFooterViewIdentifier = "PhotoBrowserFooterView"
	
	let five100ConsumerKey = "qzzP3JPuDIUzD9GiiXKE8mhq1Cw6GNj06p3PbEGz"

	// MARK: Life-cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
		
		populatePhotos()
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
		let cellLayoutAttributes = collectionView.collectionViewLayout.layoutAttributesForItemAtIndexPath(indexPath)
		cell.frame = cellLayoutAttributes!.frame
		cell.bounds = cellLayoutAttributes!.bounds
		cell.imageView.frame = cell.bounds
		
		let imageURL = (photos.objectAtIndex(indexPath.row) as! PhotoInfo).url
		
		cell.request?.cancel()
		
		if let image = imageCache.objectForKey(imageURL) as? UIImage {
			cell.imageView.image = image
		} else {
			cell.imageView.image = nil
			
			cell.request = Alamofire.request(.GET, imageURL).validate(contentType: ["image/*"]).responseImage { (request, response, result) -> Void in
				if result.isSuccess {
					self.imageCache.setObject(result.value!, forKey: imageURL)
					cell.imageView.image = result.value
				}
			}
		}
		
		print("* * * cell \(indexPath.item) * * *")
		print("- cell frame:  (x: \(cell.bounds.origin.x), y: \(cell.bounds.origin.y), w: \(cell.bounds.width), h: \(cell.bounds.height))")
		print("- cell frame:  (x: \(cell.frame.origin.x), y: \(cell.frame.origin.y), w: \(cell.frame.width), h: \(cell.frame.height))")
		print("- image frame: (x: \(cell.imageView.frame.origin.x), y: \(cell.imageView.frame.origin.y), w: \(cell.imageView.frame.width), h: \(cell.imageView.frame.height))")
		print("- image bounds:(x: \(cell.imageView.bounds.origin.x), y: \(cell.imageView.bounds.origin.y), w: \(cell.imageView.bounds.width), h: \(cell.bounds.height))")
		
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
		
		let liquidLayout = LiquidCollectionViewLayout()
		liquidLayout.delegate = self
		
		collectionView!.collectionViewLayout = liquidLayout
		
		navigationItem.title = "Featured"
		
		collectionView!.registerClass(PhotoBrowserCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: PhotoBrowserCellIdentifier)
		collectionView!.registerClass(PhotoBrowserCollectionViewLoadingCell.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: PhotoBrowserFooterViewIdentifier)
		
		refreshControl.tintColor = UIColor.whiteColor()
		refreshControl.addTarget(self, action: "handleRefresh", forControlEvents: .ValueChanged)
		collectionView!.addSubview(refreshControl)
	}
	
	override func scrollViewDidScroll(scrollView: UIScrollView) {
		if scrollView.contentOffset.y + view.frame.size.height > scrollView.contentSize.height * 0.8 {
			populatePhotos()
		}
	}
	
	func populatePhotos() {
		guard !populatingPhotos else { return }
		populatingPhotos = true

		Alamofire.request(Five100px.Router.PopularPhotos(self.currentPage)).responseJSON { (request, response, result) -> Void in
			if result.isSuccess {
				dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
					let photoInfos = (result.value?.valueForKey("photos") as! [NSDictionary]).filter({
						$0["nsfw"] as! Bool == false
					}).map {
						(photo) -> PhotoInfo in
						let imageURL = (photo["images"] as! [NSDictionary])[0]["url"] as! String
						return PhotoInfo(id: photo["id"] as! Int, url: imageURL, width: photo["width"] as? Float, height: photo["height"] as? Float)
					}
					
					let lastItem = self.photos.count
					self.photos.addObjectsFromArray(photoInfos)
					self.collectionView?.collectionViewLayout.invalidateLayout()
					
					let indexPaths = (lastItem..<self.photos.count).map { NSIndexPath(forItem: $0, inSection: 0)}
					
					dispatch_async(dispatch_get_main_queue()) {
						self.collectionView?.insertItemsAtIndexPaths(indexPaths)
					}
					
					self.currentPage++
				}
			}
			
			self.populatingPhotos = false
		}
	}
	
	func handleRefresh() {
		refreshControl.beginRefreshing()
		
		self.photos.removeAllObjects()
		self.currentPage = 1
		
		self.collectionView?.collectionViewLayout.invalidateLayout()
		self.collectionView?.reloadData()
		
		refreshControl.endRefreshing()
		
		populatePhotos()
	}
	
	// MARK: LiquidCollectionViewDelegate
	
	func collectionView(collectionView: UICollectionView?, heightForPhotoAtIndexPath indexPath: NSIndexPath, width: CGFloat) -> CGFloat {
		
		guard let photoInfo = self.photos.objectAtIndex(indexPath.item) as? PhotoInfo, let size = photoInfo.size else {
			return CGFloat(50.0)
		}
		
		let scaleFactor = width / size.width
		let height = size.height * scaleFactor
		print("* * * item \(indexPath.item): \(photoInfo.id) * * * ")
		print("photo size: (w:\(size.width), h:\(size.height))")
		print("computed photo size : (w:\(width), h:\(height))")
		
		return height
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
	var request: Alamofire.Request?
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = UIColor(white: 0.1, alpha: 1.0)
		
		imageView.frame = bounds
		imageView.contentMode = .ScaleAspectFill
		imageView.clipsToBounds = true
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
