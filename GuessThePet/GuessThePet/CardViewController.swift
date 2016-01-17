//
//  CardViewController.swift
//  GuessThePet
//
//  Created by Wei Jun Fan on 16/1/17.
//  Copyright © 2016年 ixfan. All rights reserved.
//

import UIKit

private let revealSegueId = "revealSegue"

class CardViewController: UIViewController {

	@IBOutlet private weak var cardView: UIView!
	@IBOutlet private weak var titleLabel: UILabel!

	private let flipPresentAnimationController = FlipPresentAnimationController()
	private let flipDismissAnimationController = FlipDismissAnimationController()
	private let swipeInteractionController = SwipeInteractionController()

	var pageIndex: Int?
	var petCard: PetCard?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		cardView.layer.cornerRadius = 25
		cardView.layer.masksToBounds = true

		titleLabel?.text = petCard?.description

		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap")
		cardView?.addGestureRecognizer(tapGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

		if segue.identifier == revealSegueId, let destinationViewController  = segue.destinationViewController as? RevealViewController {
			destinationViewController.petCard = petCard

			// It’s important to note that it is the view controller being presented that needs a transitioning delegate, not the view controller doing the presenting!
			destinationViewController.transitioningDelegate = self
			
			swipeInteractionController.wireToViewController(destinationViewController)
		}
    }

	func handleTap() {
		performSegueWithIdentifier(revealSegueId, sender: nil)
	}

}

// MARK: Transitioning delegate

extension CardViewController: UIViewControllerTransitioningDelegate {
	func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

		flipPresentAnimationController.originFrame = cardView.frame
		return flipPresentAnimationController
	}

	func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

		flipDismissAnimationController.destinationFrame = cardView.frame
		return flipDismissAnimationController
	}

	func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		return swipeInteractionController.interactionInProgress ? swipeInteractionController : nil
	}
}
