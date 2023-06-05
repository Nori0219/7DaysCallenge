//
//  HomeViewController.swift
//  7DaysCallenge
//
//  Created by 杉井位次 on 2023/05/23.
//

import UIKit
import RealmSwift


class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let realm = try! Realm()
    
    var topChallenge: Challenge?
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topChallenge = realm.objects(Challenge.self).last//データベースから取得した最新のChallenge
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //カスタムセルの設定
        collectionView.register(UINib(nibName: "challengeViewCell", bundle: nil), forCellWithReuseIdentifier: "ChallengeCell")
        
        navigationItem.title = "チャレンジ"
        //NavigationBarの＜Backを非表示にする　参考：https://spinners.work/posts/ios14_blank_back_button/
        if #available(iOS 14.0, *) {
            navigationItem.backButtonDisplayMode = .minimal
        } else {
            navigationItem.backButtonTitle = " "
        }
        
        // 通知の許可状態を確認
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized && settings.notificationCenterSetting == .enabled {
                print("有効な通知リクエストがあります")
            } else {
                print("有効な通知リクエストはありません")
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 最新のChallengeオブジェクトを取得
        updateTopChallenge()
        print("現在のtopChallenge: \(String(describing: topChallenge?.title))")
        print("現在のtopChallenge.streak: \(String(describing: topChallenge?.streak))")
        //TabBarを表示
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // チャレンジを更新するメソッド
    func updateTopChallenge() {
        topChallenge = realm.objects(Challenge.self).last
        collectionView.reloadData()
        scheduleNotification(for: topChallenge)
    }
    
    //セクションの中のセルの数を返す
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    //セルに表示する内容を記載する
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //storyboard上のセルを生成　storyboardのIdentifierで付けたものをここで設定する
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChallengeCell", for: indexPath)as! ChallengeViewCell
        
        cell.delegate = self
        // セルに表示する内容を設定
        // 最新のChallengeオブジェクトを使用してセルの内容を設定
        if let challenge = topChallenge {
            cell.setChallengeCell(title: challenge.title, toDo: challenge.toDo, startDate: challenge.startDate, streak: challenge.streak)
            cell.updateStreakView(challenge: challenge)
        }
        
        return cell
    }
    
    //**************************************************
    // UICollectionViewDelegateFlowLayout
    //**************************************************
    
    // UICollectionViewの外周余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
    }
    
    // Cellのサイズ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 340, height: 165)
    }
    // 行の最小余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 40
    }
    // 列の最小余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    // 通知をスケジュールするメソッド
    func scheduleNotification(for challenge: Challenge?) {
        guard let challenge = challenge else { return }
        
        if challenge.doNotification{
            print("通知メッセージを変更しますよ！")
            
            let notificationContent = UNMutableNotificationContent()
            // 通知をグループ化するためにをthreadIdentifierに設定する
            notificationContent.threadIdentifier = challenge.title
            notificationContent.title = "\(challenge.title)"
            
            // ストリークの数に応じてメッセージを変更する
            let streakMessage = ChallengeMessage.message(for: challenge.streak, challenge: challenge)
            
            //通知の内容
            notificationContent.body = streakMessage
            notificationContent.sound = UNNotificationSound.default
            let calendar = Calendar.current
            
            let components = calendar.dateComponents([.hour, .minute], from: challenge.notificationTime!)
            
            //componentsで指定した時間に繰り返し通知を送る
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            // テスト用コード：通知を5秒後に設定
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            //ChallemgeUIDで通知を識別
            let request = UNNotificationRequest(identifier: challenge.challengeUID, content: notificationContent, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("通知のスケジュール設定に失敗しました: \(error.localizedDescription)")
                } else {
                    print("通知がスケジュールされました")
                }
            }
            
        } else {
            print("通知メッセージ！")
        }
    }
    
    //画面遷移でtopChallengeの値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toArticleView" {
            let articleViewController = segue.destination as! ArticleViewController
            articleViewController.topChallenge = self.topChallenge
        }
    }
}

extension HomeViewController: ChallengeViewCellDelegate {
    func challengeCellDidTapButton(cell: ChallengeViewCell) {
        print("deligateから処理が呼ばれました")
        print("topChallenge: \(String(describing: topChallenge?.title))")
        // 画面遷移の処理を実装する
        performSegue(withIdentifier: "toArticleView", sender: nil)
    }
}



