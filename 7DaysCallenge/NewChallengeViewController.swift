//
//  NewChallengeViewController.swift
//  7DaysCallenge
//
//  Created by 杉井位次 on 2023/05/21.
//

import UIKit
import RealmSwift
import UserNotifications

class NewChallengeViewController: UIViewController {
    
    let realm = try! Realm()
    
    @IBOutlet var toDoTextField: UITextField!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var notificationLabel: UILabel!
    @IBOutlet var notificationSwich: UISwitch!
    @IBOutlet var notificarionDatePicker: UIDatePicker!
    @IBOutlet var addChallengeButton: UIButton!
    
    //challengeを入力した日付 == StartDate
    var inputedDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TabBarを非表示
        self.tabBarController?.tabBar.isHidden = true
        //NavigationBarの＜Backを非表示にする　参考：https://spinners.work/posts/ios14_blank_back_button/
        if #available(iOS 14.0, *) {
            navigationItem.backButtonDisplayMode = .minimal
        } else {
            navigationItem.backButtonTitle = " "
        }
        
    }
    
    @IBAction func checkNotification() {
        if notificationSwich.isOn {
            notificationLabel.text = "オン"
            notificationLabel.textColor = UIColor.green
        } else {
            notificationLabel.text = "オフ"
            notificationLabel.textColor = UIColor.systemGray
        }
    }
    
    
    @IBAction func addButtonTapped() {
        let newChallenge = Challenge()
        newChallenge.title = titleTextField.text!
        newChallenge.toDo = toDoTextField.text!
        newChallenge.doNotification = notificationSwich.isOn
        newChallenge.notificationTime = notificarionDatePicker.date
        newChallenge.startDate = inputedDate
        
        
        // SwitchがONの時は通知の設定
        if newChallenge.doNotification == true {
            scheduleNotification(for: newChallenge)
        }
        
        if titleTextField.text?.isEmpty ?? true || toDoTextField.text?.isEmpty ?? true{
            //アラートを表示する
            displayAlertWhenNotInput()
        } else{
            
            // 直前のチャレンジの通知をオフにする　NewChallengeをRealmに保存する前に実行する必要がある
            if let previousChallenge = getPreviousChallenge() {
                //previousChallenge.doNotification = false//Realmには保存していない
                cancelNotification(for: previousChallenge)
            }
            
            print("newChallengeをRealmへ保存可能です")
            print("newChallenge: \(newChallenge)")
            //Realmにデータを保存する
            createChallenge(charenge: newChallenge)
            
            //前の画面に戻る
            print("前の画面に戻る！")
            //self.dismiss(animated: true)
            self.navigationController?.popViewController(animated: true)
            
        }
        
        
        
    }
    
    func scheduleNotification(for challenge: Challenge) {
        let notificationContent = UNMutableNotificationContent()
        
        // 通知をグループ化するためにをthreadIdentifierに設定する
        notificationContent.threadIdentifier = challenge.title

        notificationContent.title = "\(challenge.title)"
        
        // ストリークの数に応じてメッセージを変更するこの場合は0
        let streakMessage = ChallengeMessage.message(for: 0, challenge: challenge)
        //通知の内容
        notificationContent.body = "\(streakMessage)"
        notificationContent.sound = UNNotificationSound.default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: challenge.notificationTime!)
        
        //componentsで指定した時間に繰り返し通知を送る
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        // テスト用コード通知を5秒後に設定
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
        
        // 固定されたidentifierを使用して通知リクエストを作成す
        let request = UNNotificationRequest(identifier: challenge.challengeUID, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("通知のスケジュール設定に失敗しました: \(error.localizedDescription)")
            } else {
                print("通知がスケジュールされました")
            }
        }
    }
    
    //通知設定をオフにする
    func cancelNotification(for challenge: Challenge) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [challenge.challengeUID])
        print("直前のChallengeの通知スケジュールを消去しました　challengeTitle: \(challenge.title)")
    }
    
    //直前のチャレンジを取得する
    func getPreviousChallenge() -> Challenge? {
        // チャレンジを日付の降順で取得し、最後のチャレンジを直前のチャレンジとして返す
        let challenges = realm.objects(Challenge.self).sorted(byKeyPath: "startDate", ascending: false)
        return challenges.first
    }
    
    func createChallenge(charenge: Challenge) {
        try! realm.write {
            realm.add(charenge)
        }
        print("RealmにChellengeを追加しました")
    }
    
    //toDo ChallengeのTitleとtoDoが未入力だとアラートが表示されるようにする
    func displayAlertWhenNotInput() {
        //alertを作成
        let alert = UIAlertController(
            title: "未入力の項目があります",
            message: "全ての項目を入力してください",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        ))
        present(alert, animated: true, completion: nil)
    }
}
