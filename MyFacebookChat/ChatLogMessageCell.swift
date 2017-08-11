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
        return textView
    }()
    
    override func setupViews() {
        addSubview(messageTextView)
        addConstraintsWithFromat(format: "H:|[v0]|", views: messageTextView)
        addConstraintsWithFromat(format: "V:|[v0]|", views: messageTextView)
    }
}
