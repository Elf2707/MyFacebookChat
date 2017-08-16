//
//  ChatLogMessageCell.swift
//  MyFacebookChat
//
//  Created by Elf on 12.08.17.
//  Copyright © 2017 Elf. All rights reserved.
//

import UIKit

class ChatLogMessageCell: BaseCell {
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = .clear
        textView.isEditable = false
        return textView
    }()
    
    let textBubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        
        addConstraintsWithFromat(format: "H:|-8-[v0(30)]", views: profileImageView)
        addConstraintsWithFromat(format: "V:[v0(30)]|", views: profileImageView)
    }
}
