//
//  AppDelegate.swift
//  7DaysCallenge
//
//  Created by 杉井位次 on 2023/05/21.
//

import UIKit
import RealmSwift
import UserNotifications
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate{
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let config = Realm.Configuration(
            schemaVersion: 3
            //            ,migrationBlock: nil,
            //            deleteRealmIfMigrationNeeded: true
        )
        Realm.Configuration.defaultConfiguration = config
        
        // プッシュ通知の許可を依頼する際のコード アラート、バッジ、サウンド」の3つに対しての許可をリクエスト
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if let error = error {
                print("通知の許可リクエストエラー: \(error.localizedDescription)")
            } else {
                if granted {
                    print("通知の許可が得られました")
                } else {
                    print("通知の許可が拒否されました")
                }
            }
            UNUserNotificationCenter.current().delegate = self
        }
        //Mobile Ads SDK を初期化する
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        //Rerease用の広告ID
        //ca-app-pub-2758102039369928~8589957685
        //テスト用広告ID
        //ca-app-pub-3940256099942544/5662855259
        //バナーテスト用
        //ca-app-pub-3940256099942544/2934735716
        
        
        return true
    }
    // フォアグラウンドの状態でプッシュ通知を受信した際に呼ばれるメソッド
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .badge])
    }
    // 通知をタップした時・バックグランドの状態でプッシュ通知を受信した際に呼ばれるメソッド
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // 通知のタップに応じた処理を実装する
        completionHandler()
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}
