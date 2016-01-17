//
//  FlipPresentAnimation.swift
//  GuessThePet
//
//  Created by Wei Jun Fan on 16/1/17.
//  Copyright © 2016年 ixfan. All rights reserved.
//

import UIKit

class FlipPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

	var originFrame = CGRect.zero

	func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
		return 0.6
	}

	func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		// 从 `transitionContext` 中取出动画中涉及到的 View Controllers 和 View
		guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
			let containerView = transitionContext.containerView(),
			let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
				return
		}

		// 为 "to" view 设定动画开始和结束时的 frame。这里 “to” view 从 card view 的 frame 开始，最后铺满这个屏幕。
		let initialFrame = originFrame
		let finalFrame = transitionContext.finalFrameForViewController(toVC)

		// UIView 截取 “to“ view 的画面快照并把它渲染到一个轻量级的 view 里，动画里看到的的 “to” view 其实就是这个轻量级的 view。
		let snapshot = toVC.view.snapshotViewAfterScreenUpdates(true)
		snapshot.frame = initialFrame
		snapshot.layer.cornerRadius = 25
		snapshot.layer.masksToBounds = true

		// 可以把整个动画想象成一场表演，container view 就是舞台，所有的表演都是在这个舞台上进行的。
		// Container view 已经包含了 “from” view，我们要做的就是给它添加 “to” view。
		// 这里我们把 “to” view 和它的快照放进 container view 后再把 “to” view 隐藏掉，动画过程中它不需要显示。
		containerView.addSubview(toVC.view)
		containerView.addSubview(snapshot)
		toVC.view.hidden = true

		AnimationHelper.perspectiveTransformForContainerView(containerView)
		snapshot.layer.transform = AnimationHelper.yRotation(M_PI_2)

		// 获取动画的持续时间
		let duration = transitionDuration(transitionContext)

		UIView.animateKeyframesWithDuration(
			duration,
			delay: 0,
			options: .CalculationModeCubic,
			animations: { () -> Void in
				// 沿着 “from” view 的 y 轴把它翻转 90 度，这样就把它隐藏了
				UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 1/3, animations: {
					fromVC.view.layer.transform = AnimationHelper.yRotation(-M_PI_2)
				})

				// 接着用同样的方法把 “to” view 的快照显示出来
				UIView.addKeyframeWithRelativeStartTime(1/3, relativeDuration: 1/3, animations: {
					snapshot.layer.transform = AnimationHelper.yRotation(0.0)
				})

				// 在 “to” view 的快照显示出来后再让其全屏显示
				UIView.addKeyframeWithRelativeStartTime(2/3, relativeDuration: 1/3, animations: {
					snapshot.frame = finalFrame
				})
			},
			completion: { _ in
				// 最后，显示真正的 “to” view，移除已经不需要的快照。另外，还要把 “from” view 翻转回初始状态，否则在返回 “from” view 时它是处于隐藏状态的。
				toVC.view.hidden = false
				fromVC.view.layer.transform = AnimationHelper.yRotation(0.0)
				snapshot.removeFromSuperview()

				// 调用 `completeTransition(_:)` 通知 transitioning context 动画已经完成。
				transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
		})
	}

}
