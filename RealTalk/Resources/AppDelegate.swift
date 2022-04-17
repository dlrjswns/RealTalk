    
// AppDelegate.swift
import UIKit
import Firebase
import FacebookCore

@UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        
        func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
            FirebaseApp.configure()
            ApplicationDelegate.shared.application(
                application,
                didFinishLaunchingWithOptions: launchOptions
            )
            NotificationCenter.default.post(name: .didLoginNotification, object: nil)
            
            return true
        }
        
        func application(
            _ app: UIApplication,
            open url: URL,
            options: [UIApplication.OpenURLOptionsKey : Any] = [:]
        ) -> Bool {
            ApplicationDelegate.shared.application(
                app,
                open: url,
                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
            )
        }
            
            
        
    }
