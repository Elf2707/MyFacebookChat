//
//  FriendCell.swift
//  MyFacebookChat
//
//  Created by Elf on 07.08.17.
//  Copyright © 2017 Elf. All rights reserved.
//

import UIKit

class MessageCell: BaseCell {
    var message: Message? {
        didSet {
            nameLabel.text = message?.friend?.name
            if let profileImageName = message?.friend?.profileImageName {
                let image = UIImage( named: profileImageName)
                profileImageView.image = image
                hasReadImageView.image = image
            }
            
            if let date = message?.date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                timeLabel.text = dateFormatter.string(from: date as Date)
            }
            
            messageLabel.text = message?.text
        }
    }
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 34
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let deviderLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        return view
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Friend Name"
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Message from one of the friends..."
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "12:05 pm"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    let hasReadImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.layer.cornerRadius  = 10
        iv.layer.masksToBounds = true
        return iv
    }()
    
    override func setupViews() {
        addSubview(profileImageView)
        addSubview(deviderLineView)
        
        setupContainerView()
        
        // Profile image
        addConstraintsWithFromat(format: "H:|-12-[v0(68)]", views: profileImageView)
        addConstraintsWithFromat(format: "V:|-12-[v0(68)]", views: profileImageView)
        addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        // Devide view
        addConstraintsWithFromat(format: "H:|-82-[v0]|", views: deviderLineView)
        addConstraintsWithFromat(format: "V:[v0(1)]|", views: deviderLineView)
    }
    
    private func setupContainerView() {
        let containerView = UIView()
        addSubview(containerView)
        
        addConstraintsWithFromat(format: "H:|-90-[v0]|", views: containerView)
        addConstraintsWithFromat(format: "V:[v0(50)]", views: containerView)
        addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(hasReadImageView)
        
        addConstraintsWithFromat(format: "H:|[v0][v1(80)]-8-|", views: nameLabel, timeLabel)
        addConstraintsWithFromat(format: "H:|[v0]-8-[v1(20)]-8-|", views: messageLabel, hasReadImageView)
        addConstraintsWithFromat(format: "V:|[v0(24)][v1(24)]|", views: nameLabel, messageLabel)
        addConstraintsWithFromat(format: "V:|[v0(24)]", views: timeLabel)
        addConstraintsWithFromat(format: "V:[v0(20)]|", views: hasReadImageView)
    }
}
