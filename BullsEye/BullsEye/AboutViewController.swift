//
//  AboutViewController.swift
//  BullsEye
//
//  Created by xfan on 12/07/15.
//  Copyright © 2015年 ixfan. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
	
	// MARK: Outlets
	@IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		if let htmlFile = NSBundle.mainBundle().pathForResource("BullsEye", ofType: "html") {
			let htmlData = NSData(contentsOfFile: htmlFile)
			let baseURL = NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath)
			webView?.loadData(htmlData!, MIMEType: "text/html", textEncodingName: "utf-8", baseURL: baseURL)
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: Actions
	@IBAction func close() {
		dismissViewControllerAnimated(true, completion: nil)
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
