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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		if segue.identifier == revealSegueId, let destinationViewController  = segue.destinationViewController as? RevealViewController {
			destinationViewController.petCard = petCard
		}
    }

	func handleTap() {
		performSegueWithIdentifier(revealSegueId, sender: nil)
	}

}
