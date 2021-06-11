//
//  AppDelegate.swift
//  Parth_iOSPractical
//
//  Created by Parth on 10/06/21.
//

import UIKit
import Swifter
import TwitterKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        //Twitter-kit
        TWTRTwitter.sharedInstance().start(withConsumerKey: Constant.consumerKey, consumerSecret: Constant.consumerSecretKey)
        
        if let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC  {
         
            let navigationController = UINavigationController(rootViewController: rootVC)
            
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        }
        
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let twitterHandler = TWTRTwitter.sharedInstance().application(app, open: url, options: options)
        
        return twitterHandler
    }
}

