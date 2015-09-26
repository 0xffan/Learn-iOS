//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by xfan on 21/06/15.
//  Copyright © 2015年 ixfan. All rights reserved.
//

import UIKit

class MealTableViewController: UITableViewController {
	
	struct SegueIdentifier {
		static let AddItem = "AddItem"
		static let ShowDetails = "ShowDetails"
	}
	
	// MARK: Properties
	let cellIdentifier = "MealTableViewCell"
	var meals = [Meal]()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Use the edit button item provided by the table view controller.
		navigationItem.leftBarButtonItem = editButtonItem()
		
		if let meals = loadMeals() {
			self.meals += meals
		} else {
			// load the sample data
			loadSampleMeals()
		}

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
	
	func loadSampleMeals() {
		let photo1 = UIImage(named: "meal1")
		let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4)!
		
		let photo2 = UIImage(named: "meal2")
		let meal2 = Meal(name: "Chicken and Potatoes 😋", photo: photo2, rating: 5)!
		
		let photo3 = UIImage(named: "meal3")
		let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3)!
		
		meals += [meal1, meal2, meal3]
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
        return meals.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MealTableViewCell
		let meal = meals[indexPath.row]

        cell.nameLabel.text = meal.name
		cell.photoImageView.image = meal.photo
		cell.ratingControl.rating = meal.rating

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
			meals.removeAtIndex(indexPath.row)
			saveMeals()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		switch segue.identifier {
		case .Some(SegueIdentifier.ShowDetails):
			if let mealDetailViewController = segue.destinationViewController as? MealViewController,
				let selectedMealCell = sender as? MealTableViewCell {
			
					let indexPath = tableView.indexPathForCell(selectedMealCell)!
					let selectedMeal = meals[indexPath.row]
					mealDetailViewController.meal = selectedMeal
			}
		case .Some(SegueIdentifier.AddItem):
			print("Addig new item.")
		default: break
		}
    }

	@IBAction func unwindToMealList(sender: UIStoryboardSegue) {
		
		if let sourceViewController = sender.sourceViewController as? MealViewController,
			let meal = sourceViewController.meal {
			
			if let selectedIndexPath = tableView.indexPathForSelectedRow {
				// Update an existing meal.
				meals[selectedIndexPath.row] = meal
				tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
			} else {
				// Add a new meal.
				let newIndexPath = NSIndexPath(forRow: meals.count, inSection: 0)
				meals.append(meal)
				tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
			}
			// Save meals
			saveMeals()
		}
	}
	
	// MARK: NSCoding
	func saveMeals() {
		let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path!)
		if !isSuccessfulSave {
			print("Failed to save meals!")
		}
	}
	
	func loadMeals() -> [Meal]? {
		return NSKeyedUnarchiver.unarchiveObjectWithFile(Meal.ArchiveURL.path!) as? [Meal]
	}

}
