//
//  ViewController.swift
//  MyFacebookChat
//
//  Created by Elf on 07.08.17.
//  Copyright © 2017 Elf. All rights reserved.
//

import UIKit
import CoreData

class FriendsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let cellId = "cellId"

    var fetchResultsController: NSFetchedResultsController<Friend> = {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
        let fetchRequest: NSFetchRequest<Friend> = Friend.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastMessage.date", ascending: false)]
        let frc = NSFetchedResultsController<Friend>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Recent"
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
        
        _ = FakeDataHelper.loadData()
        
        do {
            try fetchResultsController.performFetch()
        } catch let err {
            print(err)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = fetchResultsController.sections?[section].numberOfObjects {
            return count
        }
        
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MessageCell
        let friend = fetchResultsController.object(at: indexPath)
        cell?.message = friend.lastMessage
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let chatController = ChatLogViewController(collectionViewLayout: layout)
        
        let friend = fetchResultsController.object(at: indexPath)
        chatController.friend = friend
        navigationController?.pushViewController(chatController, animated: true)
    }
}

