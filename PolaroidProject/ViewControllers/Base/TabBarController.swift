//
//  TabBarController.swift
//  PolaroidProject
//
//  Created by 박성민 on 7/23/24.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .cBlack
        tabBar.unselectedItemTintColor = .cGray
        
        let nav1VC = TopicViewController()
        let nav2VC = SearchPhotoViewController()
        let nav3VC = LikePhotoViewController()
        
        let nav1 = UINavigationController(rootViewController: nav1VC)
        nav1.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_trend"), tag: 0)
        
        let nav2 = UINavigationController(rootViewController: nav2VC)
        nav2.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_search"), tag: 1)
        
        let nav3 = UINavigationController(rootViewController: nav3VC)
        nav3.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_like"), tag: 1)
        
        setViewControllers([nav1,nav2, nav3], animated: false)
    }
}
