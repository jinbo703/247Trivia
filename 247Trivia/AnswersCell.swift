//
//  AnswersCell.swift
//  247Trivia
//
//  Created by John Nik on 6/30/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class AnswersCell: UITableViewCell {
    
    let checkBox: BEMCheckBox = {
        
        let box = BEMCheckBox()
        
        box.boxType = .circle
        box.onFillColor = .yellow
        box.onAnimationType = .fill
        box.offAnimationType = .fill
        box.setOn(false, animated: true)
        box.translatesAutoresizingMaskIntoConstraints = false
        
        return box
        
    }()
    
    let answerLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Red"
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: DEVICE_WIDTH * 0.055)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    
    
    func setupViews() {
        
        self.backgroundColor = .clear
        
        addSubview(checkBox)
        addSubview(answerLabel)
        
        checkBox.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        checkBox.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        checkBox.widthAnchor.constraint(equalToConstant: 30).isActive = true
        checkBox.heightAnchor.constraint(equalToConstant: 30).isActive = true
    
        
        answerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        answerLabel.leftAnchor.constraint(equalTo: checkBox.rightAnchor, constant: 10).isActive = true
        answerLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        answerLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
