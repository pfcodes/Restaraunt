//
//  MenuController.swift
//  Restaraunt
//
//  Created by Phil on 3/8/20.
//  Copyright © 2020 AURORA Digital. All rights reserved.
//

import Foundation
import UIKit

class MenuController {
  static let shared = MenuController()
  static let orderUpdatedNotification = Notification.Name("MenuController.orderUpdated")
  static let menuDataUpdatedNotification = Notification.Name("MenuController.menuDataUpdated")

  let baseURL = URL(string: "http://localhost:8090/")!
  let documentsDirectory = FileManager.default.urls(
    for: .documentDirectory,
    in: .userDomainMask
  )[0]

  var categories: [String] {
    get { itemsByCategory.keys.sorted() }
  }
  
  var order = Order(menuItems: []) {
    didSet {
      NotificationCenter.default.post(
        name: MenuController.orderUpdatedNotification,
        object: nil
      )
    }
  }

  
  private var itemsByID = [Int:MenuItem]()
  private var itemsByCategory = [String:[MenuItem]]()
  func item(withID itemID: Int) -> MenuItem? {
    return itemsByID[itemID]
  }
  func items(forCategory category: String) -> [MenuItem]? {
    return itemsByCategory[category]
  }
  private func process(_ items: [MenuItem]) {
    itemsByID.removeAll()
    itemsByCategory.removeAll()
    
    for item in items {
      itemsByID[item.id] = item
      itemsByCategory[item.category, default: []].append(item)
    }
    
    DispatchQueue.main.async {
      NotificationCenter.default.post(
        name: MenuController.menuDataUpdatedNotification,
        object: nil
      )
    }
  }
}

// MARK: Networking methods
extension MenuController {
  func loadRemoteData() {
    let initialMenuURL = baseURL.appendingPathComponent("menu")
    let components = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true)!
    let menuURL = components.url!
    let task = URLSession.shared.dataTask(with: menuURL) { (data, _, _) in
      let jsonDecoder = JSONDecoder()
      if let data = data,
        let menuItems = try? jsonDecoder.decode(MenuItems.self, from: data) {
        self.process(menuItems.items)
      }
    }
    task.resume()
  }
  
  func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
      if let data = data,
        let image = UIImage(data: data) {
        completion(image)
      } else {
        completion(nil)
      }
    }
    task.resume()
  }
  
  func submitOrder(
    forMenuIDs menuIds: [Int],
    completion: @escaping (Int?) -> Void
  ) {
    let data: [String: [Int]] = ["menuIds": menuIds]
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

// MARK: Persistence methods
extension MenuController {
  func loadOrder() {
    let orderFileURL = documentsDirectory
      .appendingPathComponent("order")
      .appendingPathExtension("json")
    
    guard let data = try? Data(contentsOf: orderFileURL) else { return }
    
    order = (try? JSONDecoder().decode(Order.self, from: data)) ?? Order(menuItems: [])
  }
  
  func saveOrder() {
    let orderFileURL = documentsDirectory
      .appendingPathComponent("order")
      .appendingPathExtension("json")
    
    if let data = try? JSONEncoder().encode(order) {
      try? data.write(to: orderFileURL)
    }
  }
  
  func loadItems() {
    let menuItemsFileURL = documentsDirectory
      .appendingPathComponent("menuItems")
      .appendingPathExtension("json")
    
    guard let data = try? Data(contentsOf: menuItemsFileURL) else { return }
    let items = (try? JSONDecoder().decode([MenuItem].self, from: data)) ?? []
    process(items)
  }
  
  func saveItems() {
    let menuItemsFileURL = documentsDirectory
      .appendingPathComponent("menuItems")
      .appendingPathExtension("json")
    
    let items = Array(itemsByID.values)
    if let data = try? JSONEncoder().encode(items) {
      try? data.write(to: menuItemsFileURL)
    }
  }
}
