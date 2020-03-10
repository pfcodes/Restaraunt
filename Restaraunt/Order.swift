//
//  Order.swift
//  Restaraunt
//
//  Created by Phil on 3/8/20.
//  Copyright © 2020 AURORA Digital. All rights reserved.
//

import Foundation

struct Order: Codable {
  var menuItems: [MenuItem]
  
  init(menuItems: [MenuItem] = []) {
    self.menuItems = menuItems
  }
}
