//
//  AppDelegate.swift
//  TechnicalWorld
//
//  Created by Paras on 10/04/21.
//

import UIKit
import IQKeyboardManagerSwift

let ObjAppdelegate = UIApplication.shared.delegate as! AppDelegate
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navController: UINavigationController?
    
    private static var AppDelegateManager: AppDelegate = {
          let manager = UIApplication.shared.delegate as! AppDelegate
          return manager
      }()
      // MARK: - Accessors
      class func AppDelegateObject() -> AppDelegate {
          return AppDelegateManager
     }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.1
      //  UNUserNotificationCenter.current().delegate = self
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        
      //  self.registerForRemoteNotification()
       // Messaging.messaging().delegate = self
        
        let value = LocalizationSystem.sharedInstance.getLanguage()
        print("Language is \(value)")
            if value == "en"{
                LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
            }else{
                LocalizationSystem.sharedInstance.setLanguage(languageCode: "ar")
            }
        
        (UIApplication.shared.delegate as? AppDelegate)?.self.window = window
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

extension AppDelegate{
    
    func LoginNavigation(){
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        navController = sb.instantiateViewController(withIdentifier: "LoginNav") as? UINavigationController
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
    }
    
    func HomeNavigation() {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "Reveal")
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    
}

public extension UIWindow {

    var visibleViewController: UIViewController? {

        return UIWindow.getVisibleViewControllerFrom(vc: self.rootViewController)

    }

    static func getVisibleViewControllerFrom(vc: UIViewController?) -> UIViewController? {

        if let nc = vc as? UINavigationController {

            return UIWindow.getVisibleViewControllerFrom(vc: nc.visibleViewController)

        } else if let tc = vc as? UITabBarController {

            return UIWindow.getVisibleViewControllerFrom(vc: tc.selectedViewController)

        } else {

            if let pvc = vc?.presentedViewController {

                return UIWindow.getVisibleViewControllerFrom(vc: pvc)

            } else {

                return vc

            }

        }

    }

}
