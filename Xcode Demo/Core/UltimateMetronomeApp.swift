//
//  Xcode_DemoApp.swift
//  Xcode Demo
//
//  Created by Owen Hennessey on 10/6/23.
//

import SwiftUI
import SwiftData
import Firebase
import FirebaseCore
import FirebaseAuth

@main
struct UltimateMetronomeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            RootView()
//            PerformanceView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
}
