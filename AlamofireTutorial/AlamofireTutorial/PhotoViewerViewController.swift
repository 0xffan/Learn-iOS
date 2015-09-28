//
//  PhotoViewerViewController.swift
//  AlamofireTutorial
//
//  Created by Wei Jun Fan on 22/09/15.
//  Copyright © 2015年 ixfan. All rights reserved.
//

import UIKit
import Alamofire

class PhotoViewerViewController: UIViewController, UIScrollViewDelegate, UIPopoverPresentationControllerDelegate, UIActionSheetDelegate {
	
	var photoID: Int = 0
	
	let scrollView = UIScrollView()
	let imageView = UIImageView()
	let spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
	
	var photoInfo: PhotoInfo?

	// MARK: Life-cycle
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		setupView()
		
		loadPhoto()
    }
	
	func loadPhoto() {
		Alamofire.request(Five100px.Router.PhotoInfo(self.photoID, .Large)).validate().responseObject { (request, response, result: Result<PhotoInfo>) -> Void in
			guard result.isSuccess else { return }
			
			self.photoInfo = result.value
			
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				self.addButtomBar()
				self.title = self.photoInfo!.name
			})
			
			Alamofire.request(.GET, self.photoInfo!.url).validate().responseImage({ (_, _, result) -> Void in
				guard result.isSuccess else { return }
				
				self.imageView.image = result.value
				self.imageView.frame = self.centerFrameFromImage(result.value)
				
				self.spinner.stopAnimating()
				
				self.centerScrollViewContents()
			})
		}
	}
	
	func setupView() {
		spinner.center = CGPoint(x: view.center.x, y: (view.center.y - view.bounds.origin.y) / 2.0)
		spinner.hidesWhenStopped = true
		spinner.startAnimating()
		view.addSubview(spinner)
		
		scrollView.frame = view.bounds
		scrollView.delegate = self
		scrollView.minimumZoomScale = 1.0
		scrollView.maximumZoomScale = 3.0
		scrollView.zoomScale = 1.0
		view.addSubview(scrollView)
		
		imageView.contentMode = .ScaleAspectFill
		view.addSubview(imageView)
		
		let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "handleDoubleTap:")
		doubleTapRecognizer.numberOfTapsRequired = 2
		doubleTapRecognizer.numberOfTouchesRequired = 1
		scrollView.addGestureRecognizer(doubleTapRecognizer)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		if photoInfo != nil {
			navigationController?.setToolbarHidden(false, animated: true)
		}
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.setToolbarHidden(true, animated: true)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	// MARK: Bottom Bar
	
	func addButtomBar() {
		var items = [UIBarButtonItem]()
		
		let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
		
		items.append(barButtonItemWithImageNamed("hamburger", title: nil, action: "showPhotoDetails"))
		
		if photoInfo?.commentsCount > 0 {
			items.append(barButtonItemWithImageNamed("bubble", title: "\(photoInfo?.commentsCount ?? 0)", action: "showComments"))
		}
		
		items.append(flexibleSpace)
		items.append(UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "showActions"))
		items.append(flexibleSpace)
		
		items.append(barButtonItemWithImageNamed("like", title: "\(photoInfo?.votesCount ?? 0)"))
		items.append(barButtonItemWithImageNamed("heart", title: "\(photoInfo?.favoritesCount ?? 0)"))
		
		self.setToolbarItems(items, animated: true)
		navigationController?.toolbar?.barTintColor = UIColor.blackColor()
		navigationController?.toolbar?.tintColor = UIColor.whiteColor()
		navigationController?.setToolbarHidden(false, animated: true)
	}
	
	func showPhotoDetails() {
		let photoDetailsViewController = storyboard?.instantiateViewControllerWithIdentifier("PhotoDetails") as? PhotoDetailsViewController
		photoDetailsViewController?.modalPresentationStyle = .OverCurrentContext
		photoDetailsViewController?.modalTransitionStyle = .CoverVertical
		photoDetailsViewController?.photoInfo = photoInfo
		
		presentViewController(photoDetailsViewController!, animated: true, completion: nil)
	}
	
	func showComments() {
		let photoCommentsViewController = storyboard?.instantiateViewControllerWithIdentifier("PhotoComments") as? PhotoCommentsViewController
		photoCommentsViewController?.modalPresentationStyle = .Popover
		photoCommentsViewController?.modalTransitionStyle = .CoverVertical
		photoCommentsViewController?.photoID = photoID
		photoCommentsViewController?.popoverPresentationController?.delegate = self
		
		presentViewController(photoCommentsViewController!, animated: true, completion: nil)
	}
	
	func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
		return UIModalPresentationStyle.OverCurrentContext
	}
	
	func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
		let navigationController = UINavigationController(rootViewController: controller.presentedViewController)
		return navigationController
	}
	
	func barButtonItemWithImageNamed(imageName: String?, title: String?, action: Selector? = nil) -> UIBarButtonItem {
		let button = UIButton(type: .Custom)
		
		if imageName != nil {
			button.setImage(UIImage(named: imageName!)!.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
		}
		
		if title != nil {
			button.setTitle(title!, forState: .Normal)
			button.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
			
			let font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
			button.titleLabel?.font = font
		}
		
		let size = button.sizeThatFits(CGSize(width: 90.0, height: 30.0))
		button.frame.size = CGSize(width: min(size.width + 10.0, 60.0), height: size.height)
		
		if action != nil {
			button.addTarget(self, action: action!, forControlEvents: .TouchUpInside)
		}
		
		let barButton = UIBarButtonItem(customView: button)
		return barButton
	}
	
	// MARK: Download Photos
	
	func downloadPhoto() {
		Alamofire.request(Five100px.Router.PhotoInfo(self.photoID, .XLarge)).validate().responseObject { (_, _, result: Result<PhotoInfo>) -> Void in
			guard result.isSuccess else { return }
			
			let imageURL = result.value!.url
			// let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
			let destination: (NSURL, NSHTTPURLResponse) -> (NSURL) = {
				temporaryURL, response in
				let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
				return directoryURL.URLByAppendingPathComponent("\(self.photoID).\(response.suggestedFilename)")
			}
			
			let progressIndicatorView = UIProgressView(frame: CGRect(x: 0.0, y: 80.0, width: self.view.bounds.width, height: 10.0))
			progressIndicatorView.tintColor = UIColor.blueColor()
			self.view.addSubview(progressIndicatorView)
			
			Alamofire.download(.GET, imageURL, destination: destination).progress({ (_, totalBytesRead, totalBytesExpectedToRead) -> Void in
				dispatch_async(dispatch_get_main_queue(), { () -> Void in
					progressIndicatorView.setProgress(Float(totalBytesRead) / Float(totalBytesExpectedToRead), animated: true)
					
					if totalBytesRead == totalBytesExpectedToRead {
						progressIndicatorView.removeFromSuperview()
					}
				})
			})
		}
	}
	
	func showActions() {
		let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
		
		let downloadPhotoAction = UIAlertAction(title: "Download Photo", style: .Default) {
			[unowned self] (action) -> Void in
			self.downloadPhoto()
		}
		actionSheet.addAction(downloadPhotoAction)
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {
			[unowned self] (action) -> Void in
			self.dismissViewControllerAnimated(true, completion: nil)
		}
		actionSheet.addAction(cancelAction)
		
		presentViewController(actionSheet, animated: true, completion: nil)
		
		// let actionSheet1 = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Download Photo")
		// actionSheet1.showFromToolbar((navigationController?.toolbar)!)
	}
	
	/*
	func actoinSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
		if buttonIndex == 1 {
			downloadPhoto()
		}
	}
	*/
	
	// MARK: Gesture Recognizer
	
	func handleDoubleTap(gestureRecognizer: UIGestureRecognizer) {
		let pointInView = gestureRecognizer.locationInView(self.imageView)
		self.zoomInZoomOut(pointInView)
	}
	
	// MARK: ScrollView
	
	func centerFrameFromImage(image: UIImage?) -> CGRect {
		guard let _ = image else {
			return CGRectZero
		}
		
		let scaleFactor = scrollView.frame.width / image!.size.width
		let newHeight = image!.size.height * scaleFactor
		
		var newImageSize = CGSize(width: scrollView.frame.size.width, height: newHeight)
		newImageSize.height = min(scrollView.frame.size.height, newImageSize.height)
		
		let centerFrame = CGRect(x: 0.0, y: scrollView.frame.size.height / 2 - newImageSize.height / 2, width: newImageSize.width, height: newImageSize.height)
		
		return centerFrame
	}
	
	func scrollViewDidZoom(scrollView: UIScrollView) {
		centerScrollViewContents()
	}
	
	func centerScrollViewContents() {
		let boundsSize = scrollView.frame
		var contentsFrame = self.imageView.frame
		
		if contentsFrame.width < boundsSize.width {
			contentsFrame.origin.x = (boundsSize.width - contentsFrame.width) / 2
		} else {
			contentsFrame.origin.x = 0.0
		}
		
		if contentsFrame.height < boundsSize.height {
			contentsFrame.origin.y = (boundsSize.height - contentsFrame.height - scrollView.scrollIndicatorInsets.top - scrollView.scrollIndicatorInsets.bottom) / 2
		} else {
			contentsFrame.origin.y = 0.0
		}
		
		self.imageView.frame = contentsFrame
	}
	
	func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
		return imageView
	}
	
	func zoomInZoomOut(point: CGPoint!) {
		let newZoomScale = self.scrollView.zoomScale > (self.scrollView.maximumZoomScale / 2) ? self.scrollView.minimumZoomScale : self.scrollView.maximumZoomScale
		
		let scrollViewSize = self.scrollView.bounds.size
		
		let width = scrollViewSize.width / newZoomScale
		let height = scrollViewSize.height / newZoomScale
		let x = point.x - (width / 2.0)
		let y = point.y - (height / 2.0)
		
		let rectToZoom = CGRect(x: x, y: y, width: width, height: height)
		
		self.scrollView.zoomToRect(rectToZoom, animated: true)
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
