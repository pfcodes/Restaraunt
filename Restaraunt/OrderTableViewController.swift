//
//  OrderTableViewController.swift
//  Restaraunt
//
//  Created by Phil on 3/8/20.
//  Copyright © 2020 AURORA Digital. All rights reserved.
//

import UIKit

class OrderTableViewController: UITableViewController {
  var orderMinutes = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(
      tableView as Any,
      selector: #selector(UITableView.reloadData),
      name: MenuController.orderUpdatedNotification,
      object: nil
    )
    navigationItem.leftBarButtonItem = editButtonItem
  }
  
  func uploadOrder() {
    let menuIds = MenuController.shared.order.menuItems.map { $0.id }
    MenuController.shared.submitOrder(forMenuIDs: menuIds) { minutes in
      DispatchQueue.main.async {
        if let minutes = minutes {
          self.orderMinutes = minutes
          self.performSegue(withIdentifier: "ConfirmationSegue", sender: nil)
        }
      }
    }
  }
  
  func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
    let menuItem = MenuController.shared.order.menuItems[indexPath.row]
    cell.textLabel?.text = menuItem.name
    cell.detailTextLabel?.text = String(format: "$%.2f", menuItem.price)
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return MenuController.shared.order.menuItems.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCellIdentifier", for: indexPath)
    configure(cell, forItemAt: indexPath)
    return cell
  }

  // Override to support conditional editing of the table view.
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
  }

  // Override to support editing the table view.
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        // Delete the row from the data source
        MenuController.shared.order.menuItems.remove(at: indexPath.row)
        // This animation crashes:
        // https://stackoverflow.com/questions/54919569/intermittent-crash-attempt-to-delete-row-0-from-section-0-which-only-contains-0
        // tableView.deleteRows(at: [indexPath], with: .fade)
      }
  }

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

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ConfirmationSegue" {
      let orderConfirmationViewController = segue.destination as! OrderConfirmationViewController
      orderConfirmationViewController.minutes = orderMinutes
    }
  }

  @IBAction func submitTapped(_ sender: Any) {
    let orderTotal = MenuController.shared.order.menuItems.reduce(0.0) { (result, menuItem) -> Double in
      return result + menuItem.price
    }
    
    let formattedOrder = String(format: "$%.2f", orderTotal)
    
    let alert = UIAlertController(title: "Confirm Order", message: "You are about to submit your order with a total of $\(orderTotal)", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Submit", style: .default) { action in
      self.uploadOrder()
    })
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    present(alert, animated: true, completion: nil)
  }
}
