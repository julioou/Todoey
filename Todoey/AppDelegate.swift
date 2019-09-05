//
//  AppDelegate.swift
//  Todoey
//
//  Created by Treinamento on 8/29/19.
//  Copyright © 2019 trainee. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print("******************************")
        print(Date())
        print("******************************")
        
        do {
            _ = try Realm()
        }
        catch {
            print("Error initialising new Realm\(error)")
        }
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {

        
    }
    
}



