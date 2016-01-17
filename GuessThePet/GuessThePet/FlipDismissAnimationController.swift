//
//  FlipDismissAnimationController.swift
//  GuessThePet
//
//  Created by Wei Jun Fan on 16/1/17.
//  Copyright © 2016年 ixfan. All rights reserved.
//

import UIKit

class FlipDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

	var destinationFrame = CGRect.zero

	func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
		return 0.6
	}

	func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

		// Dismiss 动画与 present 动画的过程刚好相反
		
		guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
			let container = transitionContext.containerView(),
			let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
				return
		}

//		let initialFrame = transitionContext.initialFrameForViewController(fromVC)
		let finalFrame = destinationFrame

		let snapshot = fromVC.view.snapshotViewAfterScreenUpdates(false)
		snapshot.layer.cornerRadius = 25
		snapshot.layer.masksToBounds = true

		container.addSubview(toVC.view)
		container.addSubview(snapshot)
		fromVC.view.hidden = true

		AnimationHelper.perspectiveTransformForContainerView(container)
		toVC.view.layer.transform = AnimationHelper.yRotation(-M_PI_2)

		let duration = transitionDuration(transitionContext)

		UIView.animateKeyframesWithDuration(
			duration,
			delay: 0.0,
			options: .CalculationModeCubic,
			animations: { () -> Void in
				UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 1/3, animations: {
					snapshot.frame = finalFrame
				})

				UIView.addKeyframeWithRelativeStartTime(1/3, relativeDuration: 1/3, animations: {
					snapshot.layer.transform = AnimationHelper.yRotation(M_PI_2)
				})

				UIView.addKeyframeWithRelativeStartTime(2/3, relativeDuration: 1/3, animations: {
					toVC.view.layer.transform = AnimationHelper.yRotation(0.0)
				})
			},
			completion: { _ in
				fromVC.view.hidden = false
				snapshot.removeFromSuperview()
				transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
		})
		
	}

}
