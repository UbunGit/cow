//
//  AppDelegate.swift
//  Cow
//
//  Created by admin on 2021/8/4.
//

import UIKit


 @main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configDor()
        window = UIWindow()
        window?.rootViewController = HomeTabViewController()
        window?.makeKeyAndVisible()
        let timer =  Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        return true
    }



}


extension AppDelegate{
    
    @objc private func updateTime() {
        NotificationCenter.default.post(name: NSNotification.Name("GloableTimer"), object: nil)
    }
}

