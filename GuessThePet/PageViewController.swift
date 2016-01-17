//
//  PageViewController.swift
//  GuessThePet
//
//  Created by Wei Jun Fan on 16/1/17.
//  Copyright © 2016年 ixfan. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

	let petCards = PetCardStore.defaultPets()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		dataSource = self
		setViewControllers([initialViewController], direction: .Forward, animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

// MARK: Page view controller data source

extension PageViewController: UIPageViewControllerDataSource {
	func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {

		if let viewController = viewController as? CardViewController, let pageIndex = viewController.pageIndex where pageIndex > 0 {
			return viewControllerAtIndex(pageIndex - 1)
		}

		return nil
	}

	func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {

		if let viewController = viewController as? CardViewController, let pageIndex = viewController.pageIndex where pageIndex < petCards.count - 1 {
			return viewControllerAtIndex(pageIndex + 1)
		}

		return nil
	}

	func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
		return petCards.count
	}

	func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
		return 0
	}
}

// MARK: View controller provider

extension PageViewController: ViewControllerProvider {
	var initialViewController: UIViewController {
		return viewControllerAtIndex(0)!
	}

	func viewControllerAtIndex(index: Int) -> UIViewController? {
		if let cardViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CardViewController") as? CardViewController {

			cardViewController.pageIndex = index
			cardViewController.petCard = petCards[index]

			return cardViewController
		}

		return nil
	}
}
