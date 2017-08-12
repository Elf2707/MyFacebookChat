//
//  CustomTabBarController.swift
//  MyFacebookChat
//
//  Created by Elf on 12.08.17.
//  Copyright © 2017 Elf. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let friendsController = FriendsViewController(collectionViewLayout: layout)
        let recentMessagesNavController = UINavigationController(rootViewController: friendsController)
        recentMessagesNavController.tabBarItem.title = "Recent"
        recentMessagesNavController.tabBarItem.image = #imageLiteral(resourceName: "recent")
        
        let callsVc = createDummyViewController(title: "Calls", image: #imageLiteral(resourceName: "calls"))
        let groupsVc = createDummyViewController(title: "Groups", image: #imageLiteral(resourceName: "groups"))
        let peopleVc = createDummyViewController(title: "People", image: #imageLiteral(resourceName: "people"))
        let settingsVc = createDummyViewController(title: "Settings", image: #imageLiteral(resourceName: "settings"))
        
        viewControllers = [recentMessagesNavController, callsVc, groupsVc, peopleVc, settingsVc]
    }
    
    private func createDummyViewController(title: String, image: UIImage) -> UINavigationController {
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image

        return navController
    }
}
