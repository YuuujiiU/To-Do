//
//  AppDelegate.swift
//  ToDo
//
//  Created by Pasan Induwara Edirisooriya on 11/21/20.
//  Copyright © 2020 Pasan. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        guard LocalUser.current() != nil else {
            let storyboard = UIStoryboard(name: "Auth", bundle: nil)
            let topController = storyboard.instantiateViewController(withIdentifier: "AuthNC")
            setAsRoot(_controller: topController)
            return true
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let topController = storyboard.instantiateViewController(withIdentifier: "HomeNC")
        setAsRoot(_controller: topController)
        
        manageTasks()
        return true
    }
    
    func manageTasks(){
        if !UserDefaults().bool(forKey: "isFirst"){
            UserDefaults().set(true, forKey: "isFirst")
            UserDefaults().set(0, forKey: "count")
        }
    }
    // Configure Application
    func configure() {
        print("Realm path: \(String(describing: try! Realm().configuration.fileURL))")
    }
    
    func setAsRoot(_controller: UIViewController) {
        if window != nil {
            window?.rootViewController = _controller
        }
    }
    
}

