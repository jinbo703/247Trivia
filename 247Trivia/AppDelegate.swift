//
//  AppDelegate.swift
//  247Trivia
//
//  Created by John Nik on 6/28/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GADRewardBasedVideoAdDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        GADMobileAds.configure(withApplicationID: "ca-app-pub-9246759401465371~1668431441")
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let homeTapBarController = HomeTapBarController()
        let navigationController = UINavigationController(rootViewController: homeTapBarController)
        
        window?.rootViewController = navigationController
        
        navigationController.navigationBar.barTintColor = UIColor.rgb(red: 50, green: 159, blue: 244)
        
        //        UINavigationBar.appearance().tintColor = UIColor(red: 51/255, green: 98/255, blue: 149/255, alpha: 1)
        
        
        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        UITabBar.appearance().tintColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        homeTapBarController.tabBar.barTintColor = UIColor.rgb(red: 50, green: 159, blue: 244)
        application.statusBarStyle = .lightContent
        
        UINavigationBar.appearance().tintColor = .white
        
        // admob
        var rewardBasedVideo: GADRewardBasedVideoAd?

        rewardBasedVideo = GADRewardBasedVideoAd.sharedInstance()
        rewardBasedVideo?.delegate = self
        
        
        
        let request = GADRequest()
//        request.testDevices = [ kGADSimulatorID ]
        request.testDevices = [ kGADSimulatorID,                                   "2077ef9a63d2b398840261c8221a0c9b" ]
//        request.testDevices = [ "858dfd22df941cac7c169e02831836b2" ]
        rewardBasedVideo?.load(request, withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: GADRewardBasedVideoAdDelegate implementation
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didFailToLoadWithError error: Error) {
        //        adRequestInProgress = false
        print("Reward based video ad failed to load: \(error.localizedDescription)")
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        //        adRequestInProgress = false
        print("Reward based video ad is received.")
    }
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Opened reward based video ad.")
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad started playing.")
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad is closed.")
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad will leave application.")
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didRewardUserWith reward: GADAdReward) {
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
        //        earnCoins(NSInteger(reward.amount))
    }
    
    

}

