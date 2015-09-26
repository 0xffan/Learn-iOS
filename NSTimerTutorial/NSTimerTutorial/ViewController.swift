//
//  ViewController.swift
//  NSTimerTutorial
//
//  Created by xfan on 23/08/15.
//  Copyright © 2015年 ixfan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	// MARK: Properties and Variables
	
	private var counter: Int = 0 {
		didSet {
			counterLabel?.text = "\(counter)"
		}
	}
	
	private var timer = NSTimer()

	@IBOutlet weak var counterLabel: UILabel!
	
	// MARK: View Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		counterLabel?.text = "\(counter)"
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK: Actions
	
	@IBAction func startCount(sender: UIBarButtonItem!) {
		guard !timer.valid else { return () }
		timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("incrementCounter"), userInfo: nil, repeats: true)
	}
	
	@IBAction func pauseCount(sender: UIBarButtonItem!) {
		timer.invalidate()
	}
	
	@IBAction func clearCounter(sender: UIBarButtonItem!) {
		timer.invalidate()
		counter = 0
	}
	
	func incrementCounter() {
		++counter
	}

}

