//
//  MenuTableViewController.swift
//  Restaraunt
//
//  Created by Phil on 3/8/20.
//  Copyright © 2020 AURORA Digital. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
  var category: String!
  var menuItems = [MenuItem]()


  override func viewDidLoad() {
    super.viewDidLoad()
    title = category.capitalized
    updateUI()
  }
  
  func updateUI() {
    menuItems = MenuController.shared.items(forCategory: category) ?? []
    tableView.reloadData()
  }
  
  func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
    let menuItem = menuItems[indexPath.row]
    cell.textLabel?.text = menuItem.name
    cell.detailTextLabel?.text = String(format: "$%.2f", menuItem.price)
    MenuController.shared.fetchImage(url: menuItem.imageURL) { (image) in
      guard let image = image else { return }
      DispatchQueue.main.async {
        if let currentIndexPath = self.tableView.indexPath(for: cell) {
          if currentIndexPath != indexPath {
            return
          }
          
          cell.imageView?.image = image
          cell.setNeedsLayout()
        }
      }
    }
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuItems.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCellIdentifier", for: indexPath)
    configure(cell, forItemAt: indexPath)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let menuItemDetailVC = segue.destination as! MenuItemDetailViewController
    menuItemDetailVC.menuItem = menuItems[tableView.indexPathForSelectedRow!.row]
  }

  // MARK: - State preservation
  override func encodeRestorableState(with coder: NSCoder) {
    super.encodeRestorableState(with: coder)
    coder.encode(category, forKey: "category")
  }
}
