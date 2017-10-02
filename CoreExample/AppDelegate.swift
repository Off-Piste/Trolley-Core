//
//  AppDelegate.swift
//  CoreExample
//
//  Created by Harry Wright on 02.10.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

import UIKit
import TrolleyCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        TRLDefaultsManager(withKey: AppleDeviceUUIDKey).clear()
//        Trolley.setlogging(true)
        Trolley.open()

        self.window?.rootViewController?.view.backgroundColor = .blue
        return true
    }


}

