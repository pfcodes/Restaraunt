//
//  MenuController.swift
//  Restaraunt
//
//  Created by Phil on 3/8/20.
//  Copyright © 2020 AURORA Digital. All rights reserved.
//

import Foundation

class MenuController {
  let baseURL = URL(string: "http://localhost:8090/")!
  
  func fetchCategories(completion: @escaping ([String]?) -> Void) {
    let categoryURL = baseURL.appendingPathComponent("categories")
    let task = URLSession.shared.dataTask(with: categoryURL) { (data, response, error) in
      if let data = data {
        let jsonDictionary = try? JSONSerialization.jsonObject(with: data) as? [String:Any]
        let categories = jsonDictionary?["categories"] as? [String]
        completion(categories)
      } else {
        completion(nil)
      }
    }
    task.resume()
  }
  
  func fetchMenuItems(
    forCategory categoryName: String,
    completion: @escaping ([MenuItem]?) -> Void
  ) {
    let initialMenuURL = baseURL.appendingPathComponent("menu")
    var components = URLComponents(
      url: initialMenuURL,
      resolvingAgainstBaseURL: true
    )!
    components.queryItems = [URLQueryItem(name: "cateogry", value: categoryName)]
    let menuURL = components.url!
    
    let task = URLSession.shared.dataTask(with: menuURL) { (data, resonse, error) in
      let jsonDecoder = JSONDecoder()
      if let data = data,
        let menuItems = try? jsonDecoder.decode(MenuItems.self, from: data) {
          completion(menuItems.items)
      } else {
        completion(nil)
      }
    }
    
    task.resume()
  }
  
  func submitOrder(
    forMenuIDs menuIDs: [Int],
    completion: @escaping (Int?) -> Void
  ) {
    let data: [String: [Int]] = ["menuIDs": menuIDs]
    let jsonEncoder = JSONEncoder()
    let jsonData = try? jsonEncoder.encode(data)

    let orderURL = baseURL.appendingPathComponent("order")
    var request = URLRequest(url: orderURL)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData


    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
      let jsonDecoder = JSONDecoder()
      if let data = data,
        let preparationTime = try? jsonDecoder.decode(PreparationTime.self, from: data) {
        completion(preparationTime.prepTime)
      } else {
        completion(nil)
      }
    }
    
    task.resume()
  }
}

