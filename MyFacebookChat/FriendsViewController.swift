//
//  ViewController.swift
//  MyFacebookChat
//
//  Created by Elf on 07.08.17.
//  Copyright © 2017 Elf. All rights reserved.
//

import UIKit

class FriendsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let cellId = "cellId"
    
    var messages: [Message]?
 
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Recent"
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
        
        messages = FakeDataHelper.loadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count {
            return count
        }
        
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MessageCell
        if let message = messages?[indexPath.item] {
            cell?.message = message
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
}

