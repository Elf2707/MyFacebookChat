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
    
    static func createMessagesData() {
        clearData()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
        
        let mark = NSEntityDescription.insertNewObject(forEntityName: friendClassName, into: context) as! Friend;
        mark.name = "Mark Zuckerberg"
        mark.profileImageName = "mark"
        
        _ = createMessage(text: "My name is Mark nice to meet you", friend: mark, minutesAgo: 1, context: context)
        _ = createMessage(text: "Facebook is better then VK ha ha ha", friend: mark, minutesAgo: 34, context: context)
        
        let tim = NSEntityDescription.insertNewObject(forEntityName: friendClassName, into: context) as! Friend;
        tim.name = "Tim Cook"
        tim.profileImageName = "tim"

        _ = createMessage(text: "Bjnjdsn bl blalkds jdsnmjfsfjsnfjsdnfjsdjfs", friend: tim, minutesAgo: 2, context: context, sender: false)
        _ = createMessage(text: "K dfjkgnmdfgmndfkmvkjmd kmxckmvkcmvkc", friend: tim, minutesAgo: 22222, context: context)
        _ = createMessage(text: "lf,dslf,lsd,fls,dfl,sdlf,ls,fls,dlf,sdl,flsd,fl", friend: tim, minutesAgo: 22323, context: context, sender: false)
        _ = createMessage(text: "dsmfksmdfkmsdkmfksmdfs jfsdj  fsd fs f jfjsdfjsd", friend: tim, minutesAgo: 20, context: context)
        _ = createMessage(text: "sdfm kmfksmd sdfms dkmfksdmfk mskdfmskdm fksmdfksmdkl", friend: tim, minutesAgo: 21, context: context, sender: false)
        _ = createMessage(text: "s,dfl,sd ,ds, lsd, l,sdlf,sdl, flsd,flsd, lds, fld", friend: tim, minutesAgo: 22, context: context, sender: false)
        _ = createMessage(text: "Apple the best 3", friend: tim, minutesAgo: 2, context: context)
        
        _ = createMessage(text: "Apple the best 2", friend: tim, minutesAgo: 18, context: context, sender: false)
        _ = createMessage(text: "Apple the bestdfsdfsdfsdfsdfsdfsdfsdfsdfsfdsfsdfsfsdfsdfsdfsfsdfsdfsdfsdfsdfsdfsdfsd", friend: tim, minutesAgo: 180, context: context)
        _ = createMessage(text: "Apple the best 1", friend: tim, minutesAgo: 1800, context: context)
        _ = createMessage(text: "Apple makes best products", friend: tim, minutesAgo: 18000, context: context)
        _ = createMessage(text: "Apple the best", friend: tim, minutesAgo: 180000, context: context)

        let bill = NSEntityDescription.insertNewObject(forEntityName: friendClassName, into: context) as! Friend;
        bill.name = "Bill Gates"
        bill.profileImageName = "bill_gates"
        
        _ = createMessage(text: "Microsoft forever!!!!!!", friend: bill, minutesAgo: 20, context: context)
        _ = createMessage(text: "Unix sucks!!!!!!", friend: bill, minutesAgo: 60, context: context)
        
        let billClinton = NSEntityDescription.insertNewObject(forEntityName: friendClassName, into: context) as! Friend;
        billClinton.name = "Bill Clinton"
        billClinton.profileImageName = "best_bill"
        
        _ = createMessage(text: "Geeks!!! Loosers!!! I didn't do all this shit with that Monika chick", friend: billClinton, minutesAgo: 1600, context: context)
        _ = createMessage(text: "Do you beleave me?????", friend: billClinton, minutesAgo: 1800, context: context)
        
        let donaldDuck = NSEntityDescription.insertNewObject(forEntityName: friendClassName, into: context) as! Friend;
        donaldDuck.name = "Donald Duck"
        donaldDuck.profileImageName = "donald_duck"

        _ = createMessage(text: "Crya Crya Crya Crya Crya Crya Crya Crya Crya Crya Crya Crya Crya Crya Crya Crya Crya Crya Crya", friend: donaldDuck, minutesAgo: 40, context: context)
        _ = createMessage(text: "I'm a duck duck duck duck duck", friend: donaldDuck, minutesAgo: 140, context: context)
        
        do {
            try context.save()
        } catch let err {
            print(err)
        }
    }
    
    static func createMessage(text: String, friend: Friend, minutesAgo: Double, context: NSManagedObjectContext, sender: Bool = true) -> Message {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;

        let message = NSEntityDescription.insertNewObject(forEntityName: messageClassName, into: context) as! Message;
        message.friend = friend
        message.text = text
        message.date = NSDate().addingTimeInterval(-minutesAgo * 60)
        message.isSender = sender
        
        do {
            try context.save()
        } catch let err {
            print(err)
        }
        
        return message
    }
    
    static func loadData() -> [Message] {
        clearData()
        createMessagesData()
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
        var messages = Array<Message>()
        let friends = loadFriends()
        
        for friend in friends {
            let fetchRequest: NSFetchRequest<Message> = Message.fetchRequest()
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "date", ascending: false)]
            fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
            fetchRequest.fetchLimit = 1
        
            do {
                let fetchResults = try context.fetch(fetchRequest)
                if let fetchMessages = fetchResults as [Message]? {
                     messages.append(contentsOf: fetchMessages)
                }
            } catch let err {
                print(err)
            }
        }
        
        return messages.sorted(by: { $0.date!.compare($1.date! as Date) == .orderedDescending })
    }
    
    static func loadFriends() -> [Friend] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
        let fetchRequest: NSFetchRequest<Friend> = Friend.fetchRequest()
        
        do {
            let fetchResults = try context.fetch(fetchRequest)
            if let friends = fetchResults as [Friend]? {
                return friends
            }
        } catch let err {
            print(err)
        }
        
        return []
    }
    
    static func clearData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
        let fetchReuest: NSFetchRequest<Message> = Message.fetchRequest()
        fetchReuest.returnsObjectsAsFaults = false
        
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
