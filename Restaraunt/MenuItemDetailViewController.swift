//
//  MenuItemDetailViewController.swift
//  Restaraunt
//
//  Created by Phil on 3/8/20.
//  Copyright © 2020 AURORA Digital. All rights reserved.
//

import UIKit

class MenuItemDetailViewController: UIViewController {
  var menuItem: MenuItem!

  override func viewDidLoad() {
    super.viewDidLoad()
    title = menuItem.name

    // Do any additional setup after loading the view.
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
