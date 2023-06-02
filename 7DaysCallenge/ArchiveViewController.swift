//
//  ArchiveViewController.swift
//  7DaysCallenge
//
//  Created by 杉井位次 on 2023/05/31.
//

import UIKit
import RealmSwift

class ArchiveViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let realm = try! Realm()
    
    var challenges: [Challenge] = []
    var selectChallenge: Challenge?
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // RealmからArticleオブジェクトのリストを取得
        challenges = readChallenges()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //カスタムセルの設定
        collectionView.register(UINib(nibName: "challengeViewCell", bundle: nil), forCellWithReuseIdentifier: "ChallengeCell")
        
        navigationItem.title = "振り返り"
        //NavigationBarの＜Backを非表示にする
        if #available(iOS 14.0, *) {
            navigationItem.backButtonDisplayMode = .minimal
        } else {
            navigationItem.backButtonTitle = " "
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Collectionを更新する
        updateChallengeList()
        //TabBarを表示
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //Challegeの配列を読み込む
    func readChallenges() -> [Challenge] {
        Array(realm.objects(Challenge.self).sorted(byKeyPath: "startDate",ascending: false))
    }
    
    // チャレンジを更新するメソッド
    func updateChallengeList() {
        //articles = realm.objects(Article.self)
        challenges = readChallenges()
        collectionView.reloadData()
        print("ArchiveCollectionViewをリロードしました")
    }
    
    //セクションの中のセルの数を返す
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return challenges.count
    }
    
    //セルに表示する内容を記載する
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //storyboard上のセルを生成　storyboardのIdentifierで付けたものをここで設定する
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChallengeCell", for: indexPath)as! ChallengeViewCell
        
        cell.delegate = self
        // セルに表示する内容を設定
        let challenge = challenges[indexPath.row]
        cell.setChallengeCell(title: challenge.title, toDo: challenge.toDo, startDate: challenge.startDate, streak: challenge.streak)
        // ストリークの値に応じて表示色を変更する
        cell.updateStreakView(challenge: challenge)
        
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
    //画面遷移でselectChallengeの値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toArticleView" {
            let articleViewController = segue.destination as! ArticleViewController
            articleViewController.topChallenge = self.selectChallenge
        }
    }
    
}

extension ArchiveViewController: ChallengeViewCellDelegate {
    func challengeCellDidTapButton(cell: ChallengeViewCell) {
        print("deligateから処理が呼ばれました")
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        
        selectChallenge = challenges[indexPath.row]
        print("selectChallenge: \(String(describing: selectChallenge?.title))")
        // 画面遷移の処理を実装する
        performSegue(withIdentifier: "toArticleView", sender: nil)
    }
}
