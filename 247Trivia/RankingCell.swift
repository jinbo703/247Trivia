//
//  RankingCell.swift
//  247Trivia
//
//  Created by John Nik on 7/3/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class RankingCell: UITableViewCell {
    
    
    let rankingLabel: UILabel = {
        let label = UILabel()
        
        label.text = "caesar703"
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: DEVICE_WIDTH * 0.06)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "caesar703"
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: DEVICE_WIDTH * 0.06)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pointsLabel: UILabel = {
        let label = UILabel()
        
        label.text = "1234332423"
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: DEVICE_WIDTH * 0.05)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    
    
    func setupViews() {
        
        self.backgroundColor = .clear
        
        addSubview(rankingLabel)
        addSubview(userNameLabel)
        addSubview(pointsLabel)
        
        rankingLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        rankingLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        rankingLabel.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.1).isActive = true
        rankingLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        userNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        userNameLabel.leftAnchor.constraint(equalTo: rankingLabel.rightAnchor, constant: 15).isActive = true
        userNameLabel.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.5).isActive = true
        userNameLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        pointsLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        pointsLabel.leftAnchor.constraint(equalTo: userNameLabel.rightAnchor, constant: 0).isActive = true
        pointsLabel.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.4).isActive = true
        pointsLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

