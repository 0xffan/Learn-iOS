//
//  ViewController.swift
//  GuessThePet
//
//  Created by Wei Jun Fan on 16/1/17.
//  Copyright © 2016年 ixfan. All rights reserved.
//

import UIKit

protocol ViewControllerProvider {
	var initialViewController: UIViewController { get }
	func viewControllerAtIndex(index: Int) -> UIViewController?
}