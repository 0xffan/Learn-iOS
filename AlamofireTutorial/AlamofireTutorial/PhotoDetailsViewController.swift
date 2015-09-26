//
//  PhotoDetailsViewController.swift
//  AlamofireTutorial
//
//  Created by Wei Jun Fan on 26/09/15.
//  Copyright © 2015年 ixfan. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
	
	@IBOutlet weak var highestLabel: UILabel!
	@IBOutlet weak var pulseLabel: UILabel!
	@IBOutlet weak var viewsLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	
	var photoInfo: PhotoInfo?

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapRecognizer = UITapGestureRecognizer(target: self, action: "dismiss")
		tapRecognizer.numberOfTapsRequired = 1
		tapRecognizer.numberOfTouchesRequired = 1
		view.addGestureRecognizer(tapRecognizer)
		
		highestLabel.text = String(format: "%.1f", photoInfo?.highest ?? 0)
		pulseLabel.text = String(format: "%.1f", photoInfo?.pulse ?? 0)
		viewsLabel.text = "\(photoInfo?.views ?? 0)"
		descriptionLabel.text = photoInfo?.desc
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func dismiss() {
		self.dismissViewControllerAnimated(true, completion: nil)
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
