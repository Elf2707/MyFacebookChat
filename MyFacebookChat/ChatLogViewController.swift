//
//  ChatLogViewController.swift
//  MyFacebookChat
//
//  Created by Elf on 12.08.17.
//  Copyright © 2017 Elf. All rights reserved.
//

import UIKit
import CoreData

class ChatLogViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    private var cellId = "cellId"
    
    var friend: Friend? {
        didSet {
            navigationItem.title = friend?.name
        }
    }
    
    let messageInputContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        return containerView
    }()

    let inputTextField: UITextField = {
        let textFiled = UITextField()
        textFiled.placeholder = "Enter message..."
        return textFiled
    }()
    
    var bottomContraint: NSLayoutConstraint?
    
    let sendButton: UIButton = {
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1), for: .normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        sendButton.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        return sendButton
    }()
    
    lazy var fetchResultsController: NSFetchedResultsController<Message> = {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
        let fetchRequest: NSFetchRequest<Message> = Message.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "friend.name = %@", (self.friend?.name)!)
        let frc: NSFetchedResultsController<Message> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        
        return frc
    }()
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if let insertIndex = newIndexPath, type == .insert {
            blockOperations.append(BlockOperation(block: {
                self.collectionView?.insertItems(at: [insertIndex])
            }))
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView?.performBatchUpdates({ 
            for operaion in self.blockOperations {
                operaion.start()
            }
        }, completion: { (completed) in
            let lastItem = self.fetchResultsController.sections![0].numberOfObjects - 1
            let indexPath = IndexPath(item: lastItem, section: 0)
            self.collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
        })
    }
    
    var blockOperations = [BlockOperation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchResultsController.performFetch()
        } catch let err {
            print(err)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simulate", style: .plain, target: self, action: #selector(handleSimulateInsert))
        
        tabBarController?.tabBar.isHidden = true
        collectionView?.backgroundColor = .white
        collectionView?.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellId)
        view.addSubview(messageInputContainerView)
        view.addConstraintsWithFromat(format: "H:|[v0]|", views: messageInputContainerView)
        view.addConstraintsWithFromat(format: "V:[v0(48)]", views: messageInputContainerView)
        
        bottomContraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        
        setupInputComponents()
        view.addConstraint(bottomContraint!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let indexPath = IndexPath(item: (fetchResultsController.sections?[0].numberOfObjects)! - 1, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
    }
    
    func handleSimulateInsert() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        _ = FakeDataHelper.createMessage(text: "Here is a text message from simulate button", friend: friend!, minutesAgo: 2, context: context)
    }
    
    func handleSendMessage() {
        if inputTextField.text == "" {
            return
        }
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
        _ = FakeDataHelper.createMessage(text: inputTextField.text!, friend: friend!, minutesAgo: 0, context: context, sender: false)
        inputTextField.text = nil
    }
    
    func handleKeyboard(notification: Notification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            
            let isKeyboardShowing = notification.name == Notification.Name.UIKeyboardWillShow
            
            bottomContraint?.constant = isKeyboardShowing ? -(keyboardFrame?.height)! : 0
            
            if isKeyboardShowing {
                UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { (completed) in
                    let lastItem = self.fetchResultsController.sections![0].numberOfObjects - 1
                    let indexPath = IndexPath(item: lastItem, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
                })
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = fetchResultsController.sections?[0].numberOfObjects {
            return count
        }
        
        return 0
    }

    func setupInputComponents() {
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        messageInputContainerView.addSubview(topBorderView)
        messageInputContainerView.addSubview(inputTextField)
        messageInputContainerView.addSubview(sendButton)
        messageInputContainerView.addConstraintsWithFromat(format: "H:|[v0]|", views: topBorderView)
        messageInputContainerView.addConstraintsWithFromat(format: "V:|[v0(0.5)]", views: topBorderView)
        messageInputContainerView.addConstraintsWithFromat(format: "H:|-8-[v0][v1(60)]|", views: inputTextField, sendButton)
        messageInputContainerView.addConstraintsWithFromat(format: "V:|[v0]|", views: inputTextField)
        messageInputContainerView.addConstraintsWithFromat(format: "V:|[v0]|", views: sendButton)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message = fetchResultsController.object(at: indexPath)
        
        if let messageText = message.text {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
            
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        
        return CGSize(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatLogMessageCell
        let message = fetchResultsController.object(at: indexPath) 
        
        cell.messageTextView.text = message.text
        
        if let messageText = message.text, let profileImageName = message.friend?.profileImageName {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
            
            cell.profileImageView.image = UIImage(named: profileImageName)
            
            if message.isSender {
                cell.messageTextView.frame = CGRect(x: 48 + 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                cell.messageTextView.textColor = .black
                cell.textBubbleView.frame = CGRect(x: 48, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
                cell.textBubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
                cell.profileImageView.isHidden = false
            } else {
                cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 24, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                cell.messageTextView.textColor = .white
                cell.textBubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 32, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
                cell.textBubbleView.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
                cell.profileImageView.isHidden = true
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
}
