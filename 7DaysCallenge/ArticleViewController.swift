//
//  ArticleViewController.swift
//  7DaysCallenge
//
//  Created by 杉井位次 on 2023/05/23.
//

import UIKit
import RealmSwift

//class ArticleViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
class ArticleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let realm = try! Realm()
    // Articleオブジェクトのリストを格納するプロパティ
    var articles: [Article] = []
    var topChallenge: Challenge!
    

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var startDateLabel: UILabel!
    @IBOutlet var toDoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TabBarを非表示
        self.tabBarController?.tabBar.isHidden = true
        
        // RealmからArticleオブジェクトのリストを取得
        articles = readArticles() ?? []
        //TopChallegneが存在しない場合に備える
        if let topChallenge = topChallenge {
            navigationItem.title = topChallenge.title
            startDateLabel.text = "開始日：　\(formatDate2(topChallenge.startDate))"
            toDoLabel.text = topChallenge.toDo
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        //カスタムセルの設定
        collectionView.register(UINib(nibName: "ArticleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ArticleCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Tableを更新する
        print("ArticleView wii Apper")
        updateArticleList()
    }
    
    //ChallegeのUIDに対応したArticleの配列を読み込む
    func readArticles() -> [Article]? {
        guard let challengeUID = topChallenge?.challengeUID else {
            return nil
        }
        return Array(realm.objects(Article.self).filter("challengeID == %@", challengeUID).sorted(byKeyPath: "date",ascending: false))
    }
    
    // 記事一覧を更新するメソッド
    func updateArticleList() {
        //articles = realm.objects(Article.self)
        articles = readArticles() ?? []
        collectionView.reloadData()
        print("ArticleViewTableをリロードしました")
    }
    
    // セルの表示する個数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }

    // セルの内容を指定するメソッド
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCell", for: indexPath) as! ArticleCollectionViewCell
        
        let article = articles[indexPath.item]
        // セルに表示する内容を設定
        if let imageData = article.imageData {
            let image = UIImage(data: imageData)
            cell.setArticleCell(context: article.context, date: formatDate(article.date), image: image)
        } else {
            cell.setArticleCell(context: article.context, date: formatDate(article.date), image: nil)
        }
        // セルに番号を降順になるようにセット
        cell.indexLabel.text = String(articles.count - indexPath.item)
        
        cell.layer.borderWidth = 0.0
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 3)//影の方向　width、heightを負の値にすると上の方に影が表示される
        cell.layer.shadowOpacity = 0.4 //影の色の透明度
        cell.layer.shadowRadius = 5 //影のぼかし
        cell.layer.masksToBounds = false//影が表示されるように
        
        return cell
    }

    // セルが選択された時の処理
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // セルが選択された時の処理を記述する
    }

    // 日付のフォーマットを適用するメソッド
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        //formatter.dateFormat = "yyyy/MM/dd"
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年MM月dd日(E)"
        return formatter.string(from: date)
    }
    
    func formatDate2(_ date: Date) -> String {
        let formatter = DateFormatter()
        //formatter.dateFormat = "yyyy/MM/dd"
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
    //画面遷移でtopChallengeの値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewArticleView" {
            let newArticleViewController = segue.destination as! NewArticleViewController
            newArticleViewController.topChallenge = self.topChallenge
        }
    }
    
    //**************************************************
    // UICollectionViewDelegateFlowLayout
    //**************************************************
    
    // UICollectionViewの外周余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    // Cellのサイズ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 340, height: 240)
    }
    // 行の最小余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    // 列の最小余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}
