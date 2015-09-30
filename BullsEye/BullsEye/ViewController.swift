//
//  ViewController.swift
//  BullsEye
//
//  Created by xfan on 07/07/15.
//  Copyright © 2015年 ixfan. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {
	
	private struct ImageSet {
		static let SLIDER_THUMB_IMAGE_NORMAL = "SliderThumb-Normal"
		static let SLIDER_THUMB_IMAGE_HIGHLIGHTED = "SliderThumb-Highlighted"
		static let SLIDER_TRACK_RIGHT = "SliderTrack-Right"
		static let SLIDER_TRACK_LEFT = "SliderTrack-Left"
	}
	
	// MARK: Properties
	var targetValue: Int = 0 {
		didSet {
			targetValueLabel?.text = "\(targetValue)"
		}
	}
	var currentValue: Int = 0
	var totalScore: Int = 0 {
		didSet {
			scoreLabel?.text = "\(totalScore)"
		}
	}
	var round: Int = 0 {
		didSet {
			roundLabel?.text = "\(round)"
		}
	}
	
	// MARK: Outlets
	@IBOutlet weak var slider: UISlider!
	@IBOutlet weak var targetValueLabel: UILabel!
	@IBOutlet weak var scoreLabel: UILabel!
	@IBOutlet weak var roundLabel: UILabel!

	// MARK: Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		if let thumbImageNormal = UIImage(named: ImageSet.SLIDER_THUMB_IMAGE_NORMAL) {
			slider.setThumbImage(thumbImageNormal, forState: .Normal)
		}
		if let thumbImageHighlighted = UIImage(named: ImageSet.SLIDER_THUMB_IMAGE_HIGHLIGHTED) {
			slider.setThumbImage(thumbImageHighlighted, forState: UIControlState.Highlighted)
		}
		
		let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
		
		if let trackLeftImage = UIImage(named: ImageSet.SLIDER_TRACK_LEFT) {
			let trackLeftResizable = trackLeftImage.resizableImageWithCapInsets(insets)
			slider.setMinimumTrackImage(trackLeftResizable, forState: .Normal)
		}
		if let trackRightImage = UIImage(named: ImageSet.SLIDER_TRACK_RIGHT) {
			let trackRightResizable = trackRightImage.resizableImageWithCapInsets(insets)
			slider.setMaximumTrackImage(trackRightResizable, forState: .Normal)
		}
		
		startOver(nil)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func startNewRound() {
		targetValue = 1 + Int(arc4random_uniform(100))
		currentValue = 50
		slider.value = Float(currentValue)
		++round
	}

	// MARK: Actions
	
	@IBAction func showAlert() {
		let difference = abs(targetValue - currentValue)
		totalScore += 100 - difference
		
		let title: String
		switch difference {
		case 0: title = "Perfect!"
		case 1...5: title = "You almost had it!"
		case 6..<10: title = "Pretty good!"
		default: title = "Not even close..."
		}
		
		let message = "\n You scored \(100 - difference) points!"
		let alertControl = UIAlertController(title: title, message: message, preferredStyle: .Alert)
		let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) {
			act in
			self.startNewRound()
		}
		
		alertControl.addAction(action)
		
		presentViewController(alertControl, animated: true, completion: nil)
	}
	
	@IBAction func sliderMoved(slider: UISlider) {
		//print("The value of the slider is now \(slider.value)")
		currentValue = lroundf(slider.value)
	}
	
	@IBAction func startOver(sender: UIButton!) {
		totalScore = 0
		round = 0
		startNewRound()
		
		let transition = CATransition()
		transition.type = kCATransitionFade
		transition.duration = 1
		transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
		view.layer.addAnimation(transition, forKey: nil)
	}

}

