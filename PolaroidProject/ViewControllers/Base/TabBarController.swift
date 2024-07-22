//
//  TabBarController.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/22/24.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .cBlack
        tabBar.unselectedItemTintColor = .cGray
        
        let nav1VC = TopicViewController()
        let nav2VC = SearchPhotoViewConterol()
        
        let nav1 = UINavigationController(rootViewController: nav1VC)
        nav1.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "magnifyingglass"), tag: 0)
        
        let nav2 = UINavigationController(rootViewController: nav2VC)
        nav2.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), tag: 1)
        
        setViewControllers([nav1, nav2], animated: false)
    }
}
