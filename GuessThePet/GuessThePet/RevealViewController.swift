//
//  RevealViewController.swift
//  GuessThePet
//
//  Created by Wei Jun Fan on 16/1/17.
//  Copyright © 2016年 ixfan. All rights reserved.
//

import UIKit

class RevealViewController: UIViewController {

	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var imageView: UIImageView!

	var petCard: PetCard?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		titleLabel.text = petCard?.description
		imageView.image = petCard?.image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	@IBAction func dismissPressed(sender: UIButton!) {
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
