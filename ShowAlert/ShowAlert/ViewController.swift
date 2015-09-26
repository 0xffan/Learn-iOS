//
//  ViewController.swift
//  ShowAlert
//
//  Created by xfan on 29/08/15.
//  Copyright © 2015年 ixfan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
	
	// MARK: Actions
	
	@IBAction func showAlert(sender: UIButton) {
		let alert = UIAlertController(title: "Login to iCloud", message: "Login with your Apple ID", preferredStyle: UIAlertControllerStyle.Alert)
		
		alert.addTextFieldWithConfigurationHandler { (textField: UITextField) -> Void in
			textField.placeholder = "Apple ID"
		}
		
		alert.addTextFieldWithConfigurationHandler { (textField: UITextField) -> Void in
			textField.placeholder = "Password"
			textField.secureTextEntry = true
		}
		
		let loginAction = UIAlertAction(title: "Login", style: UIAlertActionStyle.Default) {
			[unowned alert] (alertAction: UIAlertAction) -> Void in
			
			guard let appleId = alert.textFields?.first?.text else { return () }
			guard let password = alert.textFields?.last?.text else { return () }
			
			print("Signing in with ID \(appleId), password: \(password)")
			
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {
			(action: UIAlertAction) -> Void in
			
			alert.dismissViewControllerAnimated(true, completion: nil)
		}
		
		alert.addAction(loginAction)
		alert.addAction(cancelAction)
		
		presentViewController(alert, animated: true, completion: nil)
		
	}
	
	@IBAction func showActionSheet(sender: UIButton) {
		let alert = UIAlertController(title: "Title of Action Sheet", message: "Message of Action Sheet", preferredStyle: .ActionSheet)
		
		let action1 = UIAlertAction(title: "Action 1", style: .Default) { (alertAction: UIAlertAction) -> Void in
			print("Perform action 1")
		}
		
		let action2 = UIAlertAction(title: "Action 2", style: .Destructive) { (alertAction: UIAlertAction) -> Void in
			print("Perform action 2")
		}
		
		let action3 = UIAlertAction(title: "Cancel", style: .Cancel) { (alertAction: UIAlertAction) -> Void in
			alert.dismissViewControllerAnimated(true, completion: nil)
		}
		
		alert.addAction(action1)
		alert.addAction(action2)
		alert.addAction(action3)
		
		presentViewController(alert, animated: true, completion: nil)
	}

	// MARK: View Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

