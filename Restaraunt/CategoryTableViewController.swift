//
//  CategoryTableViewController.swift
//  Restaraunt
//
//  Created by Phil on 3/8/20.
//  Copyright © 2020 AURORA Digital. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {
  let menuController = MenuController()
  var categories = [String]()

  override func viewDidLoad() {
    super.viewDidLoad()
    menuController.fetchCategories { (categories) in
      if let categories = categories {
        self.categories = categories
        self.updateUI(with: categories)
      }
    }
  }
  
  func updateUI(with categories: [String]) {
    DispatchQueue.main.async {
      self.categories = categories
      self.tableView.reloadData()
    }
  }
  
  func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
    cell.textLabel?.text = categories[indexPath.row].capitalized
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCellIdentifier", for: indexPath)

    // Configure the cell...
    configure(cell, forItemAt: indexPath)
    

    return cell
  }

  /*
  // Override to support conditional editing of the table view.
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      // Return false if you do not want the specified item to be editable.
      return true
  }
  */

  /*
  // Override to support editing the table view.
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
          // Delete the row from the data source
          tableView.deleteRows(at: [indexPath], with: .fade)
      } else if editingStyle == .insert {
          // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
      }
  }
  */

  /*
  // Override to support rearranging the table view.
  override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

  }
  */

  /*
  // Override to support conditional rearranging of the table view.
  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
      // Return false if you do not want the item to be re-orderable.
      return true
  }
  */

  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "MenuSegue" {
      let menuTableViewController = segue.destination as! MenuTableViewController
      menuTableViewController.category = categories[self.tableView.indexPathForSelectedRow!.row]
    }
  }
}
