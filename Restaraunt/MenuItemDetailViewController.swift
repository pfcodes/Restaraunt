//
//  MenuItemDetailViewController.swift
//  Restaraunt
//
//  Created by Phil on 3/8/20.
//  Copyright © 2020 AURORA Digital. All rights reserved.
//

import UIKit

class MenuItemDetailViewController: UIViewController {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var detailTextLabel: UILabel!
  @IBOutlet weak var addToOrderButton: UIButton!
  
  var menuItem: MenuItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = menuItem.name

    addToOrderButton.layer.cornerRadius = 5.0
    updateUI()
  }
  
  func updateUI() {
    titleLabel.text = menuItem.name
    priceLabel.text = String(format: "$%.2f", menuItem.price)
    detailTextLabel.text = menuItem.detailText
  }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
