//
//  SceneDelegate.swift
//  CatGallery
//
//  Created by Полина Терехина on 31.01.2026.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        // Котики
//        let catViewController = ViewController()
//        catViewController.title = "Котики"
//        catViewController.tabBarItem = UITabBarItem(title: "Котики", image: UIImage(systemName: "cat"), tag: 0)
//        let catNav = UINavigationController(rootViewController: catViewController)
        
        // питомец
        let profileViewController = PetProfileViewController()
        profileViewController.title = "Персонаж"
        profileViewController.tabBarItem = UITabBarItem(title: "Персонаж", image: UIImage(systemName: "person.circle"), tag: 0)
        let profileNav = UINavigationController(rootViewController: profileViewController)
                
        // Ритуалы
        let ritualsViewController = RitualsViewController()
        ritualsViewController.title = "Ритуалы"
        ritualsViewController.tabBarItem = UITabBarItem(title: "Ритуалы", image: UIImage(systemName: "sparkles"), tag: 1)
        let ritualsNav = UINavigationController(rootViewController: ritualsViewController)
                
        // Магазин
        let shopViewController = ShopViewController()
        shopViewController.title = "Лавка древностей"
        shopViewController.tabBarItem = UITabBarItem(title: "Лавка древностей", image: UIImage(systemName: "bag"), tag: 2)
        let shopNav = UINavigationController(rootViewController: shopViewController)
        
        // Пророчества
        let quoteViewController = QuoteViewController()
        quoteViewController.title = "Пророчества"
        quoteViewController.tabBarItem = UITabBarItem(title: "Пророчества", image: UIImage(systemName: "book"), tag: 3)
        let propheciesNav = UINavigationController(rootViewController: quoteViewController)
        
        //Единение
        let unityViewController = UnityRitualViewController()
        unityViewController.title = "Единение"
        unityViewController.tabBarItem = UITabBarItem(title: "Единение", image: UIImage(systemName: "sparkles"), tag: 4)
        let unityNav = UINavigationController(rootViewController: unityViewController)

        // TabBar Controller
                let tabBarController = UITabBarController()
                tabBarController.viewControllers = [profileNav, ritualsNav, shopNav, propheciesNav, unityNav]
                tabBarController.tabBar.tintColor = .systemPurple
                
                window.rootViewController = tabBarController
                self.window = window
                window.makeKeyAndVisible()
            }
        }
