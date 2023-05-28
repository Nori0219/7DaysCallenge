//
//  HomeViewController.swift
//  7DaysCallenge
//
//  Created by 杉井位次 on 2023/05/23.
//

import UIKit
import RealmSwift


class HomeViewController: UIViewController {
    
    let realm = try! Realm()
    
    var topChallenge: Challenge?
    //var selectedChallenge: Challenge? = nil //押されたセルのカテゴリーを保持
    
    @IBOutlet var container: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var toDoLabel: UILabel!
    @IBOutlet var startDateLabel: UILabel!
    @IBOutlet var streakLabel: UILabel!
    @IBOutlet var streakView1: UIView!
    @IBOutlet var streakView2: UIView!
    @IBOutlet var streakView3: UIView!
    @IBOutlet var streakView4: UIView!
    @IBOutlet var streakView5: UIView!
    @IBOutlet var streakView6: UIView!
    @IBOutlet var streakView7: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topChallenge = realm.objects(Challenge.self).last//データベースから取得した最新のChallenge
        
        // ストリークの値を取得
        let streakValue = getStreakValue()
        streakLabel.text = "\(streakValue)"
        // ストリークの値に応じて表示色を変更する
        updateStreakView(streakValue: streakValue)
        
        
        container.layer.cornerRadius = 20
        container.layer.shadowColor = UIColor.black.cgColor //影の色を決める
        container.layer.shadowOpacity = 1 //影の色の透明度
        container.layer.shadowRadius = 0 //影のぼかし
        container.layer.shadowOffset = CGSize(width: 6, height: 9) //影の方向　width、heightを負の値にすると上の方に影が表示される
        
        
        //NavigationBarの＜Backを非表示にする　参考：https://spinners.work/posts/ios14_blank_back_button/
        if #available(iOS 14.0, *) {
            navigationItem.backButtonDisplayMode = .minimal
        } else {
            navigationItem.backButtonTitle = " "
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 最新のChallengeオブジェクトを取得
        topChallenge = realm.objects(Challenge.self).last
        
        // ストリークの値を取得
        let streakValue = getStreakValue()
        print("現在のtopChallenge.streak: \(String(describing: topChallenge?.streak))")
        print("現在のstreakValue: \(streakValue)")
        streakLabel.text = "\(streakValue)"
        // ストリークの値に応じて表示色を変更する
        updateStreakView(streakValue: streakValue)
        
        // ホーム画面に表示されるChallengeの内容をセットする
        if let challenge = topChallenge {
            setChallengeView(title: challenge.title, toDo: challenge.toDo, startDate: challenge.startDate, streak: streakValue)
        }
    }
    
    // ストリークの値を取得するメソッド
    func getStreakValue() -> Int {
        // データベースからChallengeオブジェクトを取得
        guard let challenge = realm.objects(Challenge.self).last else { return 0 }
        //challenge.updateStreak()
        return challenge.streak
    }
    
    // ストリークの表示色を更新するメソッド
    func updateStreakView(streakValue: Int) {
        let streakViews = [streakView1, streakView2, streakView3, streakView4, streakView5, streakView6, streakView7]
        
        // 連続日数に応じてストリークの表示色を設定
        for (index, view) in streakViews.enumerated() {
            if index < streakValue {
                view?.backgroundColor = UIColor.green // 連続日数の範囲内は緑色に設定
            } else {
                view?.backgroundColor = UIColor.lightGray // 連続日数の範囲外はグレー色に設定
            }
        }
    }
    
    //ホーム画面に表示されるChallengeの内容をセットする
    func setChallengeView(title: String, toDo: String, startDate:Date, streak:Int) {
        titleLabel.text = title
        toDoLabel.text = toDo
        startDateLabel.text = formatDate(startDate)
        streakLabel.text = String(streak)
    }
    
    // 日付のフォーマットを適用するメソッド
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        //formatter.dateFormat = "yyyy/MM/dd"
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
    //画面遷移でtopChallengeの値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toArticleView" {
            let articleViewController = segue.destination as! ArticleViewController
            articleViewController.topChallenge = self.topChallenge
        }
    }
}


