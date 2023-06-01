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
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //カスタムセルの設定
        collectionView.register(UINib(nibName: "challengeViewCell", bundle: nil), forCellWithReuseIdentifier: "ChallengeCell")
        
        // ストリークの値を取得
        let streakValue = getStreakValue()
        streakLabel.text = "\(streakValue)"
        // ストリークの値に応じて表示色を変更する
        updateStreakView()
        
        
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
        updateTopChallenge()
        
        // ストリークの値を取得
        let streakValue = getStreakValue()
        print("現在のtopChallenge.streak: \(String(describing: topChallenge?.streak))")
        print("現在のstreakValue: \(streakValue)")
        streakLabel.text = "\(streakValue)"
        // ストリークの値に応じて表示色を変更する
        updateStreakView()
        
        // ホーム画面に表示されるChallengeの内容をセットする
        if let challenge = topChallenge {
            setChallengeView(title: challenge.title, toDo: challenge.toDo, startDate: challenge.startDate, streak: streakValue)
        }
    }
    
    // チャレンジを更新するメソッド
    func updateTopChallenge() {
        topChallenge = realm.objects(Challenge.self).last
        collectionView.reloadData()
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
        // ストリークの値に応じて表示色を変更する
        cell.updateStreakView(challenge: topChallenge!)
        
        cell.layer.borderWidth = 0.0
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 6, height: 9)//影の方向　width、heightを負の値にすると上の方に影が表示される
        cell.layer.shadowOpacity = 0.8 //影の色の透明度
        cell.layer.shadowRadius = 0 //影のぼかし
        cell.layer.masksToBounds = false//影が表示されるように
        
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
    
    func updateStreakView() {
        guard let challenge = topChallenge else {
            return
        }
        
        let streak = challenge.streak
        // Uidで紐づいたArticleの日付のみを取得した配列
        let completedDates = challenge.articles.filter({ $0.challengeID == challenge.challengeUID }).map({ $0.date })
        
        let streakViews = [streakView1, streakView2, streakView3, streakView4, streakView5, streakView6, streakView7]
        let startDate = Calendar.current.startOfDay(for: challenge.startDate)//開始日を日本のタイムに変更
        let endDate = Calendar.current.date(byAdding: .day, value: 6, to: startDate) ?? startDate
        let datesInRange = generateDates(from: startDate, to: endDate)
        
        // ストリークのviewの表示色を更新するメソッド
        for (index, view) in streakViews.enumerated() {
            if index < streak {
                //連続日数未達の日付に対応するView
                view?.backgroundColor = UIColor.green
            } else {
                let dateToCheck = Calendar.current.startOfDay(for: datesInRange[index])
                if completedDates.contains(where: { Calendar.current.startOfDay(for: $0) == dateToCheck }) {
                    view?.backgroundColor = UIColor.green // 連続日数の範囲内は緑色に設定
                } else {
                    view?.backgroundColor =  UIColor.lightGray // 連続日数の範囲外はグレー色に設定
                }
            }
        }
    }
    
    //チャレンジ開始日からの一週間の配列を返す
    func generateDates(from startDate: Date, to endDate: Date) -> [Date] {
        var dates = [Date]()
        var currentDate = startDate
        //開始日から終了日までのDateを配列にセット
        while currentDate <= endDate {
            dates.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return dates
    }
    
    // ストリークの値を取得するメソッド
    func getStreakValue() -> Int {
        // データベースからChallengeオブジェクトを取得
        guard let challenge = realm.objects(Challenge.self).last else { return 0 }
        //challenge.updateStreak()
        return challenge.streak
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
        formatter.locale = Locale(identifier: "ja_JP")
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

extension HomeViewController: ChallengeViewCellDelegate {
    func challengeCellDidTapButton(cell: ChallengeViewCell) {
        print("deligateから処理が呼ばれました")
        print("topChallenge: \(String(describing: topChallenge?.title))")
        // 画面遷移の処理を実装する
        performSegue(withIdentifier: "toArticleView", sender: nil)
    }
}



