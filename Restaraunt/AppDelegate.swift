//
//  AppDelegate.swift
//  Restaraunt
//
//  Created by Phil on 3/8/20.
//  Copyright © 2020 AURORA Digital. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    let temporaryDirectory = NSTemporaryDirectory()
    let urlCache = URLCache(
      memoryCapacity: 25_000_000,
      diskCapacity: 50_000_000,
      diskPath: temporaryDirectory
    )
    URLCache.shared = urlCache

    return true
  }
  
  func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

    MenuController.shared.loadOrder()
    MenuController.shared.loadItems()
    
    MenuController.shared.loadRemoteData()

    return true
  }
  
  func application(_ application: UIApplication, shouldRestoreSecureApplicationState coder: NSCoder) -> Bool {
    true
  }
  
  func application(_ application: UIApplication, shouldSaveSecureApplicationState coder: NSCoder) -> Bool {
    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }


}

