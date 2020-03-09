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
    MenuController.shared.fetchImage(url: menuItem.imageURL, completion: { (image) in
      DispatchQueue.main.async {
        self.imageView.image = image
      }
    })
  }

  @IBAction func addtoOrderButtonTapped(_ sender: UIButton) {
    UIView.animate(withDuration: 0.3) {
      self.addToOrderButton.transform = CGAffineTransform(scaleX: 3, y: 3)
      self.addToOrderButton.transform = CGAffineTransform(scaleX: 1, y: 1)
    }
    MenuController.shared.order.menuItems.append(menuItem)
  }
  
}
