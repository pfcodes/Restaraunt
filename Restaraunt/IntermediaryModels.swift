//
//  IntermediaryModels.swift
//  Restaraunt
//
//  Created by Phil on 3/8/20.
//  Copyright © 2020 AURORA Digital. All rights reserved.
//

import Foundation

struct Categories: Codable {
  let categories: [String]
}

struct PreparationTime: Codable {
  let prepTime: Int
  
  enum CodingKeys: String, CodingKey {
    case prepTime = "preparation_time"
  }
}
