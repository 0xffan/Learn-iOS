//
//  SwipeInteractionController.swift
//  GuessThePet
//
//  Created by Wei Jun Fan on 16/1/17.
//  Copyright © 2016年 ixfan. All rights reserved.
//

import UIKit

class SwipeInteractionController: UIPercentDrivenInteractiveTransition {

	var interactionInProgress = false
	private var shouldCompleteTransition = false
	private weak var viewController: UIViewController!

	func wireToViewController(viewController: UIViewController!) {
		self.viewController = viewController
		prepareGestureRecognizerInView(viewController.view)
	}

	private func prepareGestureRecognizerInView(view: UIView!) {
		let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: "handleGesture:")
		gesture.edges = UIRectEdge.Left
		view.addGestureRecognizer(gesture)
	}

	func handleGesture(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
		// 定义变量跟踪手势滑动状态，滑动 200 points 时就代表 100% 完成。
		let translation = gestureRecognizer.translationInView(gestureRecognizer.view!.superview!)
		var progress = translation.x / 200
		progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))

		switch gestureRecognizer.state {
		case .Began:
			// 滑动开始时触发 view controller 的 dismissal。
			interactionInProgress = true
			viewController.dismissViewControllerAnimated(true, completion: nil)
		case .Changed:
			// 滑动过程中通过调用 `updateInteractiveTransition:` 来更新 transition 的完成度。
			shouldCompleteTransition = progress > 0.5
			updateInteractiveTransition(progress)
		case .Cancelled:
			// 手势取消时， 调用 `cancelInteractionTransition` 取消动作
			interactionInProgress = false
			cancelInteractiveTransition()
		case .Ended:
			interactionInProgress = false

			if !shouldCompleteTransition {
				cancelInteractiveTransition()
			} else {
				finishInteractiveTransition()
			}
		default:
			print("Unsupported")
		}
	}

}
