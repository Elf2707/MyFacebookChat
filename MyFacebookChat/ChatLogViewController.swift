//
//  ChatLogViewController.swift
//  MyFacebookChat
//
//  Created by Elf on 12.08.17.
//  Copyright © 2017 Elf. All rights reserved.
//

import UIKit

class ChatLogViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private var cellId = "cellId"
    
    var friend: Friend? {
        didSet {
            navigationItem.title = friend?.name
            if let friendMessages = friend?.messages?.allObjects as? [Message] {
                messages = friendMessages.sorted(by: { $0.date!.compare($1.date! as Date) == .orderedAscending })
            }
        }
    }
    
    var messages: [Message]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages!.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatLogMessageCell
        cell.messageTextView.text = messages?[indexPath.item].text
        return cell
    }
}
