//
//  HomeTabBarController.swift
//  247Trivia
//
//  Created by John Nik on 6/28/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class HomeTapBarController: UITabBarController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        
    }
    
    func checkIfUserIsLoggedIn() {
        
        // user is not logged in
        IsLogin = defaults.bool(forKey: "IsLogin")
        if IsLogin == false {
            perform(#selector(handleLogOff), with: nil, afterDelay: 0)
        } else {
            
            setupControllers()
            
        }
        
    }
    
    func handleLogOff() {
        
        defaults.set(false, forKey: "IsLogin")
        defaults.synchronize()
        
        let signinController = SigninController()
        signinController.homeController = self
        let naviController = UINavigationController(rootViewController: signinController)
        present(naviController, animated: true, completion: nil)
        
    }
    
    func setupControllers() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log off", style: .plain, target: self, action: #selector(handleLogOff))
        
        let gameController = GameController()
        let gameNavigationController = UINavigationController(rootViewController: gameController)
        
        //        gameNavigationController.title = "Enjoy Quiz"
        gameNavigationController.navigationItem.title = "Enjoy Quiz"
        gameNavigationController.tabBarItem.image = UIImage(named: "play")?.withRenderingMode(.alwaysOriginal)
        gameNavigationController.tabBarItem.selectedImage = UIImage(named: "play")
//        let profileController = ProfileController()
        
        let profileController = SignupController()
        profileController.profileControllerStatus = .Update
        
        let profileNaviController = UINavigationController(rootViewController: profileController)
        //        profileNaviController.title = "Profile"
        profileNaviController.tabBarItem.image = UIImage(named: "profile")?.withRenderingMode(.alwaysOriginal)
        profileNaviController.tabBarItem.selectedImage = UIImage(named: "profile")
        
        let cartController = CartController()
        let cartNavigationController = UINavigationController(rootViewController: cartController)
        //        cartNavigationController.title = "Shop"
        cartNavigationController.tabBarItem.image = UIImage(named: "cart")?.withRenderingMode(.alwaysOriginal)
        cartNavigationController.tabBarItem.selectedImage = UIImage(named: "cart")
        
        let rankingController = RankingController()
        let rankingNavController = UINavigationController(rootViewController: rankingController)
        //        rankingNavController.title = "Ranking"
        rankingNavController.tabBarItem.image = UIImage(named: "ranking")?.withRenderingMode(.alwaysOriginal)
        rankingNavController.tabBarItem.selectedImage = UIImage(named: "ranking")
        
        let settingController = SettingController()
        let settingNavController = UINavigationController(rootViewController: settingController)
        //        settingNavController.title = "Setting"
        settingController.navigationItem.title = "Setting"
//        settingNavController.tabBarItem.title = "set"
        settingNavController.tabBarItem.image = UIImage(named: "setting")?.withRenderingMode(.alwaysOriginal)
        settingNavController.tabBarItem.selectedImage = UIImage(named: "setting")
        
        viewControllers = [settingNavController, profileNaviController, gameNavigationController, rankingNavController, cartNavigationController]
        
        if profileController.profileControllerStatus != .Photo {
            self.selectedViewController = gameNavigationController
        }
        
        
        
        tabBar.isTranslucent = false
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
        topBorder.backgroundColor = UIColor.rgb(red: 220, green: 235, blue: 235).cgColor
        tabBar.layer.addSublayer(topBorder)
        tabBar.clipsToBounds = true
        
        //        let buttonImage = UIImage(named: "play")
        //
        //        let button = UIButton(type: .custom)
        //        button.autoresizingMask = [UIViewAutoresizing.flexibleRightMargin, UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleBottomMargin, UIViewAutoresizing.flexibleTopMargin]
        //        button.frame = CGRect(x: 0.0, y: 0.0, width: (buttonImage?.size.width)!, height: (buttonImage?.size.height)!)
        //        button.setImage(buttonImage, for: .normal)
        //
        //        let heightDifference = (buttonImage?.size.height)! - tabBar.frame.size.height
        //        if heightDifference < 0 {
        //            button.center = tabBar.center
        //        } else {
        //            var center = tabBar.center as CGPoint
        //            center.y = center.y - heightDifference / 2.0
        //            button.center = center
        //        }
        //        
        //        view.addSubview(button)
    }
    
    func handleMore() {
//        do {
//            try Auth.auth().signOut()
//        } catch let logoutError {
//            print(logoutError)
//        }
        
        let loginController = SigninController()
        loginController.homeController = self
        let naviController = UINavigationController(rootViewController: loginController)
        present(naviController, animated: true, completion: nil)
        
    }

    
    
    
}

