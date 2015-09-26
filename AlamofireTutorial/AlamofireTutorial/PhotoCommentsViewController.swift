//
//  PhotoCommentsViewController.swift
//  AlamofireTutorial
//
//  Created by Wei Jun Fan on 26/09/15.
//  Copyright © 2015年 ixfan. All rights reserved.
//

import UIKit

class PhotoCommentsViewController: UITableViewController {
	
	var photoID: Int = 0
	var comments: [Comment]?
	
	// MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 50.0
		
		title = "Comment"
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "dismiss")
    }
	
	func dismiss() {
		dismissViewControllerAnimated(true, completion: nil)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: Table View
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.comments?.count ?? 0
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! PhotoCommentTableViewCell
		
		return cell
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

class PhotoCommentTableViewCell: UITableViewCell {
	
	@IBOutlet weak var userImageView: UIImageView!
	@IBOutlet weak var commentLabel: UILabel!
	@IBOutlet weak var userFullnameLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		userImageView?.layer.cornerRadius = 5.0
		userImageView?.layer.masksToBounds = true
		
		commentLabel?.numberOfLines = 0
	}
}
