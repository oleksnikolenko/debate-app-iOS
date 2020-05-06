//
//  AppDelegate.swift
//  WhoCooler
//
//  Created by Artem Trubacheev on 16.01.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import FirebaseInstanceID
import GoogleSignIn
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        UNUserNotificationCenter.current().delegate = self
        print("TOOOKEN = " + (Messaging.messaging().fcmToken ?? ""))
        UNUserNotificationCenter.current().requestAuthorization(
        options: [.alert, .badge, .sound, .carPlay]) { isSuccess, _ in
            if isSuccess {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }

        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID

        let viewController = DebateListViewController()
        window?.rootViewController = UINavigationController(rootViewController: viewController)
        window?.makeKeyAndVisible()

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(deviceToken)
    }

}

extension AppDelegate: MessagingDelegate {

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        UserDefaultsService.shared.fcmToken = fcmToken
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {

}
