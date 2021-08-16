//
//  AppDelegate.swift
//  Cow
//
//  Created by admin on 2021/8/4.
//

import UIKit
import DoraemonKit
 @main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DoraemonManager.shareInstance().install(withPid: "db4146378948b4a04e74c1172ce45590")
        window = UIWindow()
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        return true
    }



}

