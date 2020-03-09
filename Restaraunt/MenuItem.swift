//
//  MenuItem.swift
//  Restaraunt
//
//  Created by Phil on 3/8/20.
//  Copyright © 2020 AURORA Digital. All rights reserved.
//

import Foundation

struct MenuItem: Codable {
  let id: Int
  let name: String
  let detailText: String
  let price: Double
  let category: String
  let imageURL: URL
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case detailText = "description"
    case price
    case category
    case imageURL = "image_url"
  }
}

struct MenuItems: Codable {
  let items: [MenuItem]
}
