//
//  AppDelegate.swift
//  WhoCooler
//
//  Created by Artem Trubacheev on 16.01.2020.
//  Copyright © 2020 Artem Trubacheev. All rights reserved.
//

import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseMessaging
import FirebaseInstanceID
import GoogleSignIn
import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(
        options: [.alert, .badge, .sound, .carPlay]) { isSuccess, _ in
            if isSuccess {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }

        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID

        let viewController = DebateListViewController()
        window?.rootViewController = UINavigationController(rootViewController: viewController)
        window?.makeKeyAndVisible()

        UserDefaultsService.shared.sessionCount += 1

        if
            let payload = launchOptions?[.remoteNotification] as? [AnyHashable: Any],
            let debateId = payload["debate-id"] as? String
        {
            AnalyticsService.shared.trackEvent(.openPush(id: debateId))
            let debateVC = DebateDetailViewController(debate: Debate.byId(id: debateId))
            viewController.navigationController?.pushViewController(debateVC, animated: true)
        }

        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        InstanceID.instanceID().instanceID { (result, _) in
            if result != nil {
                // Receive notifications from the "all" topic
                #if DEBUG
                Messaging.messaging().subscribe(toTopic: "test_devices")
                #endif
            }
        }

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        GIDSignIn.sharedInstance().handle(url)
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEvents.activateApp()
    }

    func application(
        _ application: UIApplication,
        open url: URL,
        sourceApplication: String?,
        annotation: Any
    ) -> Bool {
        return ApplicationDelegate.shared.application(
            application,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation
        )
    }

}

extension AppDelegate: MessagingDelegate {

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        UserDefaultsService.shared.fcmToken = fcmToken
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {

}
