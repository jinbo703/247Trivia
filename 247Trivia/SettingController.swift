//
//  SettingController.swift
//  247Trivia
//
//  Created by John Nik on 6/28/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import GoogleMobileAds
import AdSupport

class SettingController: UIViewController {
    
    var rewardBasedVideo: GADRewardBasedVideoAd?
    
    lazy var freeCoinsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Free Coins", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleRewardVideo), for: .touchUpInside)
        return button
    }()
    
    func handleRewardVideo() {
        
        if GADRewardBasedVideoAd.sharedInstance().isReady == true {
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        rewardBasedVideo = GADRewardBasedVideoAd.sharedInstance()
//        rewardBasedVideo?.delegate = self
        
        let uuid: UUID = ASIdentifierManager.shared().advertisingIdentifier
        print("\(uuid.uuidString.md5)")
        
        
        
//        let request = GADRequest()
//        request.testDevices = [ "858dfd22df941cac7c169e02831836b2" ]
//
//        rewardBasedVideo?.load(request, withAdUnitID: "ca-app-pub-9246759401465371/6098631048")
        
        
        setupNavigationBar()
//        setupFreeCoinsButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Setting"
    }
    
    private func setupFreeCoinsButton() {
        
        view.addSubview(freeCoinsButton)
        
        freeCoinsButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        freeCoinsButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        freeCoinsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        freeCoinsButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        
    }

    
    
    
    func setupNavigationBar() {
        
        view.backgroundColor = UIColor(r: 255, g: 89, b: 100, a: 1)
        
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "247_clock")
        backgroundImageView.alpha = 0.4
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(backgroundImageView)
        
        backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 25).isActive = true
        backgroundImageView.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.85).isActive = true
        backgroundImageView.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.85).isActive = true
    }
    
    // MARK: GADRewardBasedVideoAdDelegate implementation
    
//    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
//                            didFailToLoadWithError error: Error) {
//        
//        print("Reward based video ad failed to load: \(error.localizedDescription)")
//    }
//    
//    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
//        
//        print("Reward based video ad is received.")
//    }
//    
//    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
//        
//        print("Opened reward based video ad.")
//    }
//    
//    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
//        print("Reward based video ad started playing.")
//    }
//    
//    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
//        print("Reward based video ad is closed.")
//    }
//    
//    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
//        print("Reward based video ad will leave application.")
//    }
//    
//    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
//                            didRewardUserWith reward: GADAdReward) {
//        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
////        earnCoins(NSInteger(reward.amount))
//    }
    
}




