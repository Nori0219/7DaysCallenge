//
//  HomeViewController.swift
//  7DaysCallenge
//
//  Created by 杉井位次 on 2023/05/23.
//

import UIKit
import RealmSwift
import GoogleMobileAds


class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let realm = try! Realm()
    
    var topChallenge: Challenge?
    
    @IBOutlet var messageTextView: UITextView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var bannerView: GADBannerView!
    
    //テスト用のバナー広告ID
    let adBannerID = "ca-app-pub-3940256099942544/2934735716"
    //本番用のバナー広告ID
    // let adBannerID = "ca-app-pub-2758102039369928/1406452290"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //topChallenge = realm.objects(Challenge.self).last//データベースから取得した最新のChallenge
        
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
        
        
        // GADBannerViewのプロパティを設定
        bannerView.adUnitID = adBannerID
        bannerView.rootViewController = self
        
        // 広告読み込み
        bannerView.load(GADRequest())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 最新のChallengeオブジェクトを取得
        updateTopChallenge()
        //アプリレビュー依頼ダイアログの表示
        appReviewAlert()
        print("現在のtopChallenge: \(String(describing: topChallenge?.title))")
        print("現在のtopChallenge.streak: \(String(describing: topChallenge?.streak))")
        //TabBarを表示
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //streakがトリガーとなりレビューダイアログを開く
    func appReviewAlert() {
        if topChallenge?.streak == 2 {
            ReviewHelper.showReviewDialog(from: self)
        }
        print("appReviewAlert()の呼び出し")
    }
    
    // チャレンジを更新するメソッド
    func updateTopChallenge() {
        topChallenge = realm.objects(Challenge.self).last
        collectionView.reloadData()
        scheduleNotification(for: topChallenge)
        if let challenge = topChallenge {
            print("topChallenge: \(String(describing: topChallenge!))")
            messageTextView.text = setMessage(challenge: challenge)
            collectionView.isHidden = false
            print("Labelにメッセージを代入したよん")
        } else {
            collectionView.isHidden = true
            messageTextView.text = "おや？\nまだチャレンジを設定していないようですね\n下のボタンから1週間チャレンジを始めましょう！"
        }
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
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
            
            //メッセージテイストに合わせて通知を設定する
            let streakMessage: String
            streakMessage = setMessage(challenge: challenge)
            
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
                    print("streakMessage: \(streakMessage)")
                }
            }
            
        } else {
            print("通知メッセージ！")
        }
    }
    
    func setMessage(challenge: Challenge) -> String {
        let Message: String
        switch challenge.messageStyle {
        case "標準":
            Message = ChallengeMessage.normal(for: challenge.streak, challenge: challenge)
        case "熱血":
            Message = ChallengeMessage.passion(for: challenge.streak, challenge: challenge)
        case "勇者":
            Message = ChallengeMessage.hero(for: challenge.streak, challenge: challenge)
        case "癒し":
            Message = ChallengeMessage.cheer(for: challenge.streak, challenge: challenge)
        default:
            Message = ChallengeMessage.normal(for: challenge.streak, challenge: challenge)
        }
        print("Message:\(Message)")
        
        return Message
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



