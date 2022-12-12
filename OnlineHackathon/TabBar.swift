//
//  TabBar.swift
//  OnlineHackathon
//
//  Created by Ruslan Ismailov on 12/12/22.
//

import UIKit

class TabBar: UITabBarController {
    
    let firstPage = FirstPage()
    let searchPage = SearchPage()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
//        tabBar.tintColor = .white
        
        setupVCs()
    }
    
    func setupVCs(){
        viewControllers = [
            createNavController(for: firstPage, title: "Photo Stock", image: UIImage(systemName: "homekit")!),
            createNavController(for: searchPage, title: "Search", image: UIImage(systemName: "magnifyingglass")!),
        ]
        
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController,
                                                      title: String,
                                                      image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        
        navController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: #selector(backBtn))
        
        rootViewController.navigationItem.title = title
        return navController
    }
    
    @objc private func backBtn(){
        dismiss(animated: true)
    }

}
