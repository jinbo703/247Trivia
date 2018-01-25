//
//  RankingController.swift
//  247Trivia
//
//  Created by John Nik on 6/28/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class RankingController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellId = "cellId"
    
    var users = [User]()
    var userId = String()
    
    lazy var rankingTableView: UITableView = {
        
        var tableView = UITableView();
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
//        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userId = defaults.string(forKey: "userId")!
        
        setupNavigationBar()
        setupRankingTableView()
        
        rankingTableView.register(RankingCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Ranking"
//        rankingTableView.reloadData()
        fetchRankingDataFromServer()
    }
    
    func fetchRankingDataFromServer() {
        
        ProgressHudHelper.showLoadingHud(withText: "Loading...")
        users.removeAll()
        handleRanking()
        
    }

    func handleRanking() {
        
        
        
        let paramDic = ["userId": userId] as [String : String]
        
        API?.executeHTTPRequest(Post, url: GET_RANKING_URL, parameters: paramDic , completionHandler: { (responseDic) in
            
            self.parseRankingResponseWith(responseDic: responseDic!)
            
        }, errorHandler: { (error) in
            print("updateError--", error!)
            ProgressHudHelper.hideLoadingHud()
            showAlertMessage(vc: self, titleStr: "Something went wrong!", messageStr: "Try again later")
        })
        
        
    }

    private func parseRankingResponseWith(responseDic: [AnyHashable: Any]) {
        
        print(responseDic)
        
        let result = responseDic["status"] as! String
        
        if result == "SUCCESS" {
            
            
            
            let usersArr = responseDic["users"] as! [[String: Any]]
            
            for i in 0 ..< usersArr.count {
                let user = User()
                
                user.ranking = (usersArr[i]["ranking"] as? String)! + " ."
                user.userId = usersArr[i]["userId"] as? String
                user.userName = usersArr[i]["userName"] as? String
                user.points = (usersArr[i]["points"] as? String)! + " PTS"
                
                users.append(user)
            }
            
            if usersArr.count > 20 {
                let user = User()
                
                user.ranking = "..."
                user.userId = "0"
                user.userName = "..."
                user.points = "..."
                users.insert(user, at: 10)
            }
            
            rankingTableView.reloadData()
            ProgressHudHelper.hideLoadingHud()
            
        } else {
            
            ProgressHudHelper.hideLoadingHud()
            showAlertMessage(vc: self, titleStr: "Something went wrong!", messageStr: "Try again later")
        }
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
    
    private func setupRankingTableView() {
        
        view.addSubview(rankingTableView)
        
        rankingTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        rankingTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        rankingTableView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: -40).isActive = true
        rankingTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RankingCell
        
        let user = users[indexPath.row]
        
        cell.rankingLabel.text = user.ranking
        cell.userNameLabel.text = user.userName
        cell.pointsLabel.text = user.points
        
        if userId  == user.userId {
            cell.rankingLabel.textColor = .white
            cell.userNameLabel.textColor = .white
            cell.pointsLabel.textColor = .white
        } else {
            cell.rankingLabel.textColor = .black
            cell.userNameLabel.textColor = .black
            cell.pointsLabel.textColor = .black
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) {
            return DEVICE_WIDTH * 0.09
        }
        return DEVICE_WIDTH * 0.125
    }

    
}

