//
//  FakeDataHelper.swift
//  MyFacebookChat
//
//  Created by Elf on 09.08.17.
//  Copyright © 2017 Elf. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FakeDataHelper: NSObject {
    static let friendClassName = String(describing: Friend.self)
    static let messageClassName = String(describing: Message.self)
    
    static func createMessagesData() -> [Message] {
        clearData()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
        
        let mark = NSEntityDescription.insertNewObject(forEntityName: friendClassName, into: context) as! Friend;
        mark.name = "Mark Zuckerberg"
        mark.profileImageName = "mark"
        
        let markMsg1 = createMessage(text: "My name is Mark nice to meet you", friend: mark, minutesAgo: 1, context: context)
        
        let tim = NSEntityDescription.insertNewObject(forEntityName: friendClassName, into: context) as! Friend;
        tim.name = "Tim Cook"
        tim.profileImageName = "tim"

        let timMsg1 = createMessage(text: "Apple makes best products", friend: tim, minutesAgo: 10, context: context)

        let bill = NSEntityDescription.insertNewObject(forEntityName: friendClassName, into: context) as! Friend;
        bill.name = "Bill Gates"
        bill.profileImageName = "bill_gates"
        
        let billMsg1 = createMessage(text: "Microsoft forever!!!!!!", friend: bill, minutesAgo: 20, context: context)
        let billMsg2 = createMessage(text: "Unix sucks!!!!!!", friend: bill, minutesAgo: 60, context: context)
        
        let billClinton = NSEntityDescription.insertNewObject(forEntityName: friendClassName, into: context) as! Friend;
        billClinton.name = "Bill Clinton"
        billClinton.profileImageName = "best_bill"
        
        let billCliMsg1 = createMessage(text: "Geeks!!! Loosers!!! I didn't do all this shit with that Monika chick", friend: billClinton, minutesAgo: 30, context: context)
        
        let donaldDuck = NSEntityDescription.insertNewObject(forEntityName: friendClassName, into: context) as! Friend;
        donaldDuck.name = "Donald Duck"
        donaldDuck.profileImageName = "donald_duck"

        let donaldMsg1 = createMessage(text: "Crya Crya Crya Crya Crya Crya Crya Crya Crya Crya Crya Crya Crya Crya Crya Crya Crya Crya Crya", friend: donaldDuck, minutesAgo: 40, context: context)
        
        do {
            try context.save()
        } catch let err {
            print(err)
        }
        
        return [markMsg1, timMsg1, billMsg1, billMsg2, billCliMsg1, donaldMsg1]
    }
    
    static func createMessage(text: String, friend: Friend, minutesAgo: Double, context: NSManagedObjectContext) -> Message {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;

        let message = NSEntityDescription.insertNewObject(forEntityName: messageClassName, into: context) as! Message;
        message.friend = friend
        message.text = text
        message.date = NSDate().addingTimeInterval(minutesAgo * 60)
        
        do {
            try context.save()
        } catch let err {
            print(err)
        }
        
        return message
    }
    
    static func loadData() -> [Message] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
        let fetchRequest: NSFetchRequest<Message> = Message.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "date", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "friend.name = %@", "Bill Gates")
        fetchRequest.fetchLimit = 1
        
        do {
            let fetchResults = try context.fetch(fetchRequest)
            if let messages = fetchResults as [Message]? {
                if messages.count == 0 {
                    return createMessagesData()
                } else {
                    return messages
                }
            }
        } catch let err {
            print(err)
        }
        
        return []
    }
    
    static func clearData() {
        let fetchReuest: NSFetchRequest<Message> = Message.fetchRequest()
        fetchReuest.returnsObjectsAsFaults = false
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
        
        do {
            let fetchResults = try context.fetch(fetchReuest)
            if let messages = fetchResults as [Message]? {
                for message in messages {
                    context.delete(message.friend!)
                    context.delete(message)
                }
            }
        } catch let err {
            print(err)
        }
    }
}
